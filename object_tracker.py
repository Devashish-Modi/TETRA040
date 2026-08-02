"""
PHASE 9: Multi-Object Tracking
===============================
Takes Phase 8's per-frame detections (which have no memory — frame 2 has
no idea "goat" in frame 2 is the same goat as frame 1) and links them into
persistent tracked identities: Goat #1, Goat #2, Human #1, etc.

This is a lightweight IoU-based tracker (no external dependency like
DeepSORT needed) — appropriate for the free-tier / single-camera scope
of this project.
"""

import time
from collections import OrderedDict


def iou(box_a, box_b):
    """Intersection-over-Union between two (x1, y1, x2, y2) boxes."""
    ax1, ay1, ax2, ay2 = box_a
    bx1, by1, bx2, by2 = box_b

    inter_x1 = max(ax1, bx1)
    inter_y1 = max(ay1, by1)
    inter_x2 = min(ax2, bx2)
    inter_y2 = min(ay2, by2)

    inter_w = max(0, inter_x2 - inter_x1)
    inter_h = max(0, inter_y2 - inter_y1)
    inter_area = inter_w * inter_h

    area_a = max(0, ax2 - ax1) * max(0, ay2 - ay1)
    area_b = max(0, bx2 - bx1) * max(0, by2 - by1)
    union = area_a + area_b - inter_area

    return inter_area / union if union > 0 else 0.0


class Track:
    """A single tracked object's persistent state across frames."""

    def __init__(self, track_id, detection, frame_idx):
        self.id = track_id
        self.label = detection["label"]
        self.box = detection["box"]
        self.confidence = detection["confidence"]
        self.is_known = detection["is_known"]
        self.last_seen_frame = frame_idx
        self.first_seen_frame = frame_idx
        self.missed_frames = 0
        self.hits = 1  # how many frames this track has been matched on
        self.created_at = time.time()

    def update(self, detection, frame_idx):
        self.box = detection["box"]
        self.confidence = detection["confidence"]
        self.label = detection["label"]        # allow label to firm up over time
        self.is_known = detection["is_known"]
        self.last_seen_frame = frame_idx
        self.missed_frames = 0
        self.hits += 1

    def mark_missed(self):
        self.missed_frames += 1


class MultiObjectTracker:
    """
    Assigns and maintains persistent track IDs for Phase 8's detections.

    Matching strategy: greedy IoU matching per frame. Each existing track
    is matched to the detection with the highest IoU above `iou_threshold`,
    provided that detection hasn't already been claimed by a better-matching
    track this frame. Unmatched tracks accumulate `missed_frames`; once that
    exceeds `max_missed`, the track is deregistered (the object left frame,
    or detection dropped it for too long).
    """

    def __init__(self, iou_threshold: float = 0.3, max_missed: int = 15):
        self.iou_threshold = iou_threshold
        self.max_missed = max_missed
        self.tracks = OrderedDict()   # track_id -> Track
        self._next_id = 1
        self._frame_idx = 0

    def update(self, detections):
        """
        detections: list of dicts from Phase 8's ObjectDetector.detect(),
        each with keys: label, confidence, box, class_id, is_known.

        Returns: list of active Track objects for this frame (post-update).
        """
        self._frame_idx += 1

        # Build all (track, detection, iou) candidate pairs above threshold.
        candidates = []
        for track_id, track in self.tracks.items():
            for det_idx, det in enumerate(detections):
                score = iou(track.box, det["box"])
                if score >= self.iou_threshold:
                    candidates.append((score, track_id, det_idx))

        # Greedy assignment: highest IoU pairs win first, each track and
        # each detection can only be used once.
        candidates.sort(key=lambda c: c[0], reverse=True)
        matched_tracks = set()
        matched_dets = set()

        for score, track_id, det_idx in candidates:
            if track_id in matched_tracks or det_idx in matched_dets:
                continue
            self.tracks[track_id].update(detections[det_idx], self._frame_idx)
            matched_tracks.add(track_id)
            matched_dets.add(det_idx)

        # Any existing track not matched this frame: mark missed.
        for track_id, track in list(self.tracks.items()):
            if track_id not in matched_tracks:
                track.mark_missed()
                if track.missed_frames > self.max_missed:
                    del self.tracks[track_id]

        # Any detection not claimed by an existing track: it's a new object.
        for det_idx, det in enumerate(detections):
            if det_idx not in matched_dets:
                new_id = self._next_id
                self._next_id += 1
                self.tracks[new_id] = Track(new_id, det, self._frame_idx)

        return list(self.tracks.values())

    def active_counts(self):
        """Per-label count of currently active tracks — e.g. {'goat': 3, 'human': 1}."""
        counts = {}
        for track in self.tracks.values():
            counts[track.label] = counts.get(track.label, 0) + 1
        return counts


def draw_tracks(frame, tracks, cv2_module=None):
    """
    Draws track IDs on top of Phase 8's boxes. Kept separate from cv2
    drawing in ObjectDetector so tracking stays usable headlessly
    (e.g. logging-only deployments) without an OpenCV dependency forced in.
    """
    import cv2 as cv2_local
    cv2 = cv2_module or cv2_local

    for track in tracks:
        x1, y1, x2, y2 = track.box
        color = (0, 200, 0) if track.is_known else (0, 165, 255)
        text = f"#{track.id} {track.label}"
        cv2.putText(frame, text, (x1, min(y2 + 20, frame.shape[0] - 5)),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.55, color, 2)
    return frame


if __name__ == "__main__":
    import argparse
    import cv2

    from camera_integration import create_camera_source   # Phase 7
    from object_detector import ObjectDetector             # Phase 8

    parser = argparse.ArgumentParser(description="Phase 9: Multi-Object Tracking")
    parser.add_argument("--source-type", required=True,
                         choices=["webcam", "usb", "rtsp", "ip", "video", "folder"])
    parser.add_argument("--source-path", required=True)
    parser.add_argument("--model", default="runs/train/weights/best.pt")
    parser.add_argument("--class-names", default="class_names.json")
    parser.add_argument("--iou-threshold", type=float, default=0.3)
    parser.add_argument("--max-missed", type=int, default=15)
    parser.add_argument("--no-display", action="store_true")
    args = parser.parse_args()

    camera = create_camera_source(args.source_type, args.source_path)
    detector = ObjectDetector(args.model, args.class_names)
    tracker = MultiObjectTracker(iou_threshold=args.iou_threshold, max_missed=args.max_missed)

    print("[Phase 9] Tracking started. Press 'q' to quit." if not args.no_display
          else "[Phase 9] Running headless...")

    try:
        while True:
            ok, frame = camera.read_frame()
            if not ok:
                print("[Phase 9] Source ended.")
                break

            annotated, detections = detector.detect(frame)
            tracks = tracker.update(detections)
            annotated = draw_tracks(annotated, tracks)

            counts = tracker.active_counts()
            if counts:
                print(f"[Phase 9] Active: {counts}")

            if not args.no_display:
                cv2.imshow("Phase 9 - Multi-Object Tracking", annotated)
                if cv2.waitKey(1) & 0xFF == ord("q"):
                    break
    finally:
        camera.release()
        if not args.no_display:
            cv2.destroyAllWindows()
        print("[Phase 9] Stopped cleanly.")
