"""
PHASE 8: Object Detection
==========================
Loads the model trained in Phase 6 (best.pt) and runs it on frames pulled
from ANY camera source built in Phase 7 (webcam, USB, RTSP, IP cam, video
file, or image folder) via the unified CameraSource.read_frame() interface.

This is the phase where Phase 6's trained weights and Phase 7's camera
abstraction actually meet for the first time.
"""

import cv2
import time
import json
import argparse
from pathlib import Path
from collections import deque

from ultralytics import YOLO

# Import Phase 7's camera abstraction so Phase 8 never talks to raw
# cv2.VideoCapture / RTSP / image-folder logic directly.
from camera_integration import create_camera_source  # Phase 7 module


# --------------------------------------------------------------------------
# Config
# --------------------------------------------------------------------------

DEFAULT_CONF_THRESHOLD = 0.45   # below this -> treat as "Unknown"
DEFAULT_IOU_THRESHOLD = 0.45    # NMS overlap threshold
FPS_WINDOW = 30                 # matches Phase 7's rolling FPS window

# Species the model is actually trained on (mirrors data.yaml's names list).
# A prediction landing on one of these IDs above threshold is a real class;
# below threshold, or a shape/motion blob the model isn't confident about,
# gets bucketed as Unknown Animal / Unknown Object rather than a wrong guess.
KNOWN_ANIMAL_CLASSES = {
    1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15  # cow..lion, excluding human/dog
}
HUMAN_CLASS = 0
DOG_CAT_CLASSES = {7, 8}


class ObjectDetector:
    """
    Wraps a trained YOLO model and turns raw frames into labeled,
    boxed detections — with a confidence-based fallback for anything
    the model isn't sure about, rather than a silently wrong label.
    """

    def __init__(self, model_path: str, class_names_path: str = None,
                 conf_threshold: float = DEFAULT_CONF_THRESHOLD,
                 iou_threshold: float = DEFAULT_IOU_THRESHOLD):
        self.model_path = Path(model_path)
        if not self.model_path.exists():
            raise FileNotFoundError(
                f"Trained model not found at {model_path}. "
                f"Did Phase 6 training finish and export best.pt?"
            )

        self.model = YOLO(str(self.model_path))
        self.conf_threshold = conf_threshold
        self.iou_threshold = iou_threshold

        # Class names should come from the SAME source Phase 4/5/6 used,
        # so IDs never drift across phases.
        if class_names_path and Path(class_names_path).exists():
            with open(class_names_path, "r") as f:
                self.class_names = json.load(f)
        else:
            self.class_names = self.model.names  # fallback to model's own mapping

        self._fps_timestamps = deque(maxlen=FPS_WINDOW)

    def detect(self, frame):
        """
        Run detection on a single frame.
        Returns (annotated_frame, detections) where detections is a list of
        dicts: {label, confidence, box, is_known}.
        """
        results = self.model.predict(
            frame,
            conf=self.conf_threshold,
            iou=self.iou_threshold,
            verbose=False,
        )[0]

        detections = []
        annotated = frame.copy()

        for box in results.boxes:
            cls_id = int(box.cls[0])
            conf = float(box.conf[0])
            x1, y1, x2, y2 = map(int, box.xyxy[0])

            label, is_known = self._resolve_label(cls_id, conf)

            detections.append({
                "label": label,
                "confidence": round(conf, 3),
                "box": (x1, y1, x2, y2),
                "class_id": cls_id,
                "is_known": is_known,
            })

            color = (0, 200, 0) if is_known else (0, 165, 255)  # orange = unknown
            cv2.rectangle(annotated, (x1, y1), (x2, y2), color, 2)
            text = f"{label} {conf:.2f}"
            cv2.putText(annotated, text, (x1, max(y1 - 8, 0)),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.55, color, 2)

        self._update_fps()
        fps = self.current_fps()
        cv2.putText(annotated, f"FPS: {fps:.1f}", (10, 25),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 255), 2)

        return annotated, detections

    def _resolve_label(self, cls_id: int, conf: float):
        """
        Confidence-threshold fallback (see data.yaml note): the model is
        NEVER trained to output "Unknown" directly — YOLO always emits its
        best guess. This is the layer that decides when to trust that guess
        vs. bucket it as Unknown Animal / Unknown Object, so a low-confidence
        misfire doesn't get reported as a confident wrong species.
        """
        name = self.class_names.get(cls_id, None) if isinstance(self.class_names, dict) \
            else (self.class_names[cls_id] if cls_id < len(self.class_names) else None)

        if name is None:
            return "Unknown Object", False

        if conf < self.conf_threshold:
            # Still distinguish animal-shaped vs. object-shaped low-confidence
            # hits so downstream tracking (Phase 9) has a coarse bucket to
            # work with instead of one catch-all "Unknown".
            if cls_id in KNOWN_ANIMAL_CLASSES or cls_id in DOG_CAT_CLASSES or cls_id == HUMAN_CLASS:
                return "Unknown Animal", False
            return "Unknown Object", False

        return name, True

    def _update_fps(self):
        self._fps_timestamps.append(time.time())

    def current_fps(self):
        if len(self._fps_timestamps) < 2:
            return 0.0
        elapsed = self._fps_timestamps[-1] - self._fps_timestamps[0]
        if elapsed <= 0:
            return 0.0
        return (len(self._fps_timestamps) - 1) / elapsed


def run(source_type: str, source_path: str, model_path: str,
        class_names_path: str = None, display: bool = True,
        save_output: str = None):
    """
    Main Phase 8 loop: Phase 7 CameraSource -> ObjectDetector -> display/save.
    """
    camera = create_camera_source(source_type, source_path)
    detector = ObjectDetector(model_path, class_names_path)

    writer = None
    if save_output:
        # Lazily created once we know frame size from the first frame.
        writer = {"path": save_output, "handle": None}

    print(f"[Phase 8] Detection started. Source: {source_type} ({source_path})")
    print(f"[Phase 8] Model: {model_path}")
    print("[Phase 8] Press 'q' to quit." if display else "[Phase 8] Running headless...")

    try:
        while True:
            ok, frame = camera.read_frame()
            if not ok:
                print("[Phase 8] No more frames / source ended.")
                break

            annotated, detections = detector.detect(frame)

            if detections:
                summary = ", ".join(f"{d['label']}({d['confidence']})" for d in detections)
                print(f"[Phase 8] {summary}")

            if writer is not None:
                if writer["handle"] is None:
                    h, w = annotated.shape[:2]
                    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
                    writer["handle"] = cv2.VideoWriter(writer["path"], fourcc, 20.0, (w, h))
                writer["handle"].write(annotated)

            if display:
                cv2.imshow("Phase 8 - Object Detection", annotated)
                if cv2.waitKey(1) & 0xFF == ord("q"):
                    break

    finally:
        camera.release()
        if writer is not None and writer["handle"] is not None:
            writer["handle"].release()
        if display:
            cv2.destroyAllWindows()
        print("[Phase 8] Stopped cleanly.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Phase 8: Object Detection")
    parser.add_argument("--source-type", required=True,
                         choices=["webcam", "usb", "rtsp", "ip", "video", "folder"],
                         help="Matches Phase 7's CameraSource types")
    parser.add_argument("--source-path", required=True,
                         help="Device index, RTSP URL, video file path, or image folder path")
    parser.add_argument("--model", default="runs/train/weights/best.pt",
                         help="Path to Phase 6's trained weights")
    parser.add_argument("--class-names", default="class_names.json",
                         help="Path to Phase 4's canonical class_names.json")
    parser.add_argument("--no-display", action="store_true")
    parser.add_argument("--save", default=None, help="Optional output video path")
    args = parser.parse_args()

    run(
        source_type=args.source_type,
        source_path=args.source_path,
        model_path=args.model,
        class_names_path=args.class_names,
        display=not args.no_display,
        save_output=args.save,
    )
