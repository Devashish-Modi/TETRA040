"""
model2_decision_engine.py

MODEL 2: AI Decision Engine
Project: AI-Powered Intelligent Animal Detection, Identification & Smart Monitoring System

Purpose
-------
Model 2 NEVER performs object detection itself. It only consumes the
structured output already produced by Model 1 (detection_and_tracking.py's
`detection_log`) and decides what action to take - alert level, hardware
trigger, or no action - based on rules.

This keeps the two models cleanly separated: Model 1's job is "what did the
camera see," Model 2's job is "given what was seen, what should happen now."

Data contract (what Model 1 must provide per detection):
    {
        "type": str,          # e.g. "cow", "unknown_animal", "human"
        "confidence": float,  # 0.0-1.0
        "timestamp": str,     # ISO format
        "track_id": int|None, # persistent ID from Phase 9 tracking
        "is_human": bool,
    }

Design principles followed:
    - Model 2 has ZERO detection logic - it trusts Model 1's output completely
    - All hardware actions go through HardwareManager - never direct GPIO/serial/wifi calls
    - Config-driven thresholds (config.yaml's decision_engine section)
    - Per-track cooldown, so the same tracked animal doesn't re-trigger an
      alert every single frame it's visible in
"""

from __future__ import annotations

import logging
import time
from typing import Dict, List, Optional

import yaml

from hardware.hardware_manager import HardwareManager
from animal_database import DatabaseManager

logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(message)s")
logger = logging.getLogger("Model2DecisionEngine")


class DecisionEngine:
    """
    Model 2. Reads detection entries produced by Model 1 and decides what
    action to take, entirely independent of how detection itself works.
    """

    def __init__(self, config_path: str = "config.yaml", hardware: Optional[HardwareManager] = None) -> None:
        """
        Parameters
        ----------
        config_path : str
            Path to config.yaml - shared with HardwareManager so both
            respect the same hardware_mode and threshold settings.
        hardware : HardwareManager, optional
            Pass an existing instance to share hardware state across
            multiple engines/modules. If omitted, creates its own.
        """
        self.config = self._load_config(config_path)
        de_config = self.config.get("decision_engine", {})

        self.alert_confidence = de_config.get("animal_alert_confidence", 0.6)
        self.level_1_distance = de_config.get("level_1_distance_threshold", 10.0)
        self.level_2_distance = de_config.get("level_2_distance_threshold", 5.0)
        self.level_3_distance = de_config.get("level_3_distance_threshold", 2.0)
        self.cooldown_seconds = de_config.get("repeat_alert_cooldown_seconds", 30)

        self.hardware = hardware or HardwareManager(config_path=config_path)

        # Species threshold database - looked up once per species before the
        # decision rules run. config.yaml only holds the NAME of the env var
        # that contains the real connection string - the string itself is
        # never in config or in code (see animal_database.py).
        db_config = self.config.get("database", {})
        self.database = DatabaseManager(
            url_env_var=db_config.get("url_env_var", "ANIMAL_DB_URL"),
            table_name=db_config.get("table_name", "animal_name"),
        )

        # Tracks the last time each track_id triggered an alert, so the
        # same animal walking through frame 500 times doesn't sound the
        # buzzer 500 times.
        self._last_alert_time: Dict[int, float] = {}

        # FALLBACK cooldown for Model 1 sources that don't do tracking
        # (e.g. yolo_webcam_demo.py has no track_id - every detection is
        # "unlinked"). Keyed by class name instead of track_id, so at least
        # the same SPECIES doesn't spam an alert every single frame.
        self._last_alert_time_by_type: Dict[str, float] = {}

        logger.info(
            "DecisionEngine initialized. alert_confidence=%.2f, hardware_mode=%s",
            self.alert_confidence, self.hardware.mode,
        )

    @staticmethod
    def normalize_detection(detection: dict) -> dict:
        """
        Makes Model 2 work with ANY Model 1 output format, not just the
        tracking-enabled one. If a detection dict is missing 'is_human' or
        'track_id' (e.g. it came from yolo_webcam_demo.py, which has no
        tracking and no human/animal split field), this fills in sensible
        defaults so the rest of the decision logic doesn't need to care
        which Model 1 file produced the data.

        Fills in:
            is_human  -> True if type == "person" or "human", else False
            track_id  -> None if not present (treated as "untracked")
        """
        normalized = dict(detection)  # don't mutate the caller's dict
        if "is_human" not in normalized:
            normalized["is_human"] = normalized.get("type", "").lower() in ("person", "human")
        if "track_id" not in normalized:
            normalized["track_id"] = None
        return normalized

    def _load_config(self, config_path: str) -> dict:
        try:
            with open(config_path, "r") as f:
                return yaml.safe_load(f) or {}
        except FileNotFoundError:
            logger.warning("Config not found at %s - using default thresholds.", config_path)
            return {}

    def _is_on_cooldown(self, track_id: Optional[int], class_name: str) -> bool:
        """
        Returns True if this detection should be suppressed due to cooldown.

        If a track_id is available (tracking-enabled Model 1), cooldown is
        per-individual - precise, since we know it's the SAME animal.

        If track_id is None (untracked Model 1, e.g. yolo_webcam_demo.py),
        falls back to per-species cooldown - less precise (two different
        cows within the cooldown window would both be suppressed), but far
        better than alerting on every single frame for what's likely the
        same animal standing in view.
        """
        if track_id is not None:
            last_time = self._last_alert_time.get(track_id)
            if last_time is None:
                return False
            return (time.time() - last_time) < self.cooldown_seconds

        # Fallback: per-type cooldown
        last_time = self._last_alert_time_by_type.get(class_name)
        if last_time is None:
            return False
        return (time.time() - last_time) < self.cooldown_seconds

    def _mark_alerted(self, track_id: Optional[int], class_name: str) -> None:
        """Records the alert time, using track_id if available, otherwise falling back to class_name."""
        if track_id is not None:
            self._last_alert_time[track_id] = time.time()
        else:
            self._last_alert_time_by_type[class_name] = time.time()

    def process_detection(self, detection: dict, distance_meters: Optional[float] = None) -> str:
        """
        Processes ONE detection entry from Model 1's detection_log and
        decides the appropriate action. This is the core decision logic.

        Works with EITHER Model 1 output format:
            - Tracking-enabled (detection_and_tracking.py): has track_id, is_human
            - Simple (yolo_webcam_demo.py): missing track_id/is_human -
              normalize_detection() fills in sensible defaults automatically.

        Parameters
        ----------
        detection : dict
            One entry from Model 1's detection_log.
        distance_meters : float, optional
            Distance to the detected object, if available (e.g. from a
            future ultrasonic sensor via hardware.read_sensor(), or
            estimated from bounding box size). If omitted, distance-based
            escalation is skipped and only a basic alert decision is made.

        Returns
        -------
        str
            The action taken: "no_action", "logged_only", "level_1_alert",
            "level_2_alert", or "level_3_alert".
        """
        detection = self.normalize_detection(detection)
        class_name = detection["type"]
        track_id = detection["track_id"]

        # Step 0: Search the deterrent_priority table BEFORE any decision
        # rules run. If this (animal, weather, period) combination was
        # already searched earlier in this session, DatabaseManager logs
        # that and reuses the cached result instead of querying again.
        #
        # This table's lvl1/lvl2/lvl3 are DETERRENT DEVICES to trigger at
        # each escalation level (e.g. Laser/Speaker/Water Sprinkler) - NOT
        # distance thresholds. The distance thresholds that decide WHICH
        # level to escalate to still come from config.yaml below.
        species_info = self.database.lookup_species(class_name)

        # Rule 1: Humans are logged, never trigger a wildlife alert -
        # this is a direct requirement from the master prompt.
        if detection["is_human"]:
            logger.info("Human detected (track_id=%s) - logged, no alert triggered.", track_id)
            return "logged_only"

        # Rule 2: Low-confidence / unknown detections are logged but don't
        # trigger hardware action - we don't want to sound alarms over
        # shaky, uncertain guesses.
        if detection["confidence"] < self.alert_confidence:
            logger.info(
                "Detection '%s' below alert confidence (%.2f < %.2f) - logged only.",
                class_name, detection["confidence"], self.alert_confidence,
            )
            return "logged_only"

        # Rule 3: Respect cooldown - don't re-trigger for the same tracked
        # animal (or same species, if untracked) every single frame.
        if self._is_on_cooldown(track_id, class_name):
            logger.info(
                "'%s' (track_id=%s) is on alert cooldown - skipping re-trigger.",
                class_name, track_id,
            )
            return "logged_only"

        # Rule 4: Escalate based on distance, if available. Thresholds
        # come from config.yaml (same for every species) - the database
        # doesn't provide distance thresholds, only deterrent devices.
        if distance_meters is not None:
            if distance_meters <= self.level_3_distance:
                self.hardware.send_level3()
                self._mark_alerted(track_id, class_name)
                self._log_alert(3, class_name, distance_meters, track_id, species_info)
                return "level_3_alert"
            elif distance_meters <= self.level_2_distance:
                self.hardware.send_level2()
                self._mark_alerted(track_id, class_name)
                self._log_alert(2, class_name, distance_meters, track_id, species_info)
                return "level_2_alert"
            elif distance_meters <= self.level_1_distance:
                self.hardware.send_level1()
                self._mark_alerted(track_id, class_name)
                self._log_alert(1, class_name, distance_meters, track_id, species_info)
                return "level_1_alert"
            else:
                logger.info("'%s' detected but outside all alert zones (%.1fm).", class_name, distance_meters)
                return "logged_only"

        # No distance info available - trigger a basic Level 1 alert since
        # confidence was high enough to be considered a real detection.
        self.hardware.send_level1()
        self._mark_alerted(track_id, class_name)
        self._log_alert(1, class_name, None, track_id, species_info)
        return "level_1_alert"

    def _log_alert(self, level: int, class_name: str, distance_meters: Optional[float],
                   track_id: Optional[int], species_info: Optional[dict]) -> None:
        """
        Prints/logs the actual deterrent device (the "task") for this
        escalation level, pulled from the deterrent_priority table.
        Falls back to a generic message if the species has no database row.
        """
        device = species_info.get(f"lvl{level}") if species_info else None
        distance_str = f"{distance_meters:.1f}m" if distance_meters is not None else "no distance data"

        if device:
            print(f"[Task] LEVEL {level} ALERT: '{class_name}' at {distance_str} "
                  f"(track_id={track_id}) -> trigger '{device}'")
        else:
            print(f"[Task] LEVEL {level} ALERT: '{class_name}' at {distance_str} "
                  f"(track_id={track_id}) -> no deterrent device on file, using default hardware trigger")

        log_fn = logger.warning if level >= 2 else logger.info
        log_fn(
            "LEVEL %d ALERT: '%s' at %s (track_id=%s, device=%s)",
            level, class_name, distance_str, track_id, device,
        )

    def process_detection_log(self, detection_log: List[dict]) -> List[str]:
        """
        Processes an entire detection_log (Model 1's full output for a
        session) and returns the action taken for each entry, in order.
        """
        actions = [self.process_detection(entry) for entry in detection_log]
        summary = {}
        for action in actions:
            summary[action] = summary.get(action, 0) + 1
        logger.info("Decision summary across %d detections: %s", len(detection_log), summary)
        return actions


# ---------------------------------------------------------------------------
# Example usage - wiring Model 1's output directly into Model 2
#
# Model 1 = yolo_webcam_demo.py (per user's choice - the simple, untracked
# detection file). Its detection_log entries lack 'track_id' and 'is_human',
# but normalize_detection() (called automatically inside process_detection)
# fills those in, so Model 2 works with this file exactly as well as it
# would with the tracking-enabled detection_and_tracking.py.
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    from yolo_webcam_demo import run_on_video
    # To use webcam or photo instead, swap for:
    #   from yolo_webcam_demo import run_demo as run_on_video  # (webcam)
    #   from yolo_webcam_demo import run_on_image              # (photo)

    detection_log = run_on_video(video_path="Vedio.mp4")

    engine = DecisionEngine(config_path="config.yaml")
    actions = engine.process_detection_log(detection_log)

    print("\n=== Model 2 Decision Summary ===")
    for detection, action in zip(detection_log, actions):
        # .get() used here since this Model 1 source has no 'track_id' field at all
        print(f"{detection['timestamp']} | {detection['type']} -> {action}")
