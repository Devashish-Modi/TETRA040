"""
PHASE 7: Camera Integration
============================
One abstraction layer so every source — webcam, USB camera, RTSP/CCTV
stream, IP camera, video file, or a folder of images — exposes the exact
same interface: read_frame(). Phase 8 (Object Detection) and Phase 9
(Tracking) only ever talk to this interface, never to raw cv2.VideoCapture
or file-listing logic directly.
"""

import cv2
import time
import glob
from pathlib import Path
from collections import deque

FPS_WINDOW = 30  # rolling window size for smoothed FPS reporting


class CameraSource:
    """Base interface every source implements identically."""

    def __init__(self):
        self._fps_timestamps = deque(maxlen=FPS_WINDOW)

    def read_frame(self):
        """Returns (success: bool, frame: np.ndarray | None)."""
        raise NotImplementedError

    def release(self):
        raise NotImplementedError

    def _tick_fps(self):
        self._fps_timestamps.append(time.time())

    def current_fps(self):
        if len(self._fps_timestamps) < 2:
            return 0.0
        elapsed = self._fps_timestamps[-1] - self._fps_timestamps[0]
        return (len(self._fps_timestamps) - 1) / elapsed if elapsed > 0 else 0.0


class LocalDeviceSource(CameraSource):
    """Webcam or USB camera — a local device index, no reconnect logic needed."""

    def __init__(self, device_index: int = 0):
        super().__init__()
        self.cap = cv2.VideoCapture(int(device_index))
        if not self.cap.isOpened():
            raise RuntimeError(f"Could not open local device index {device_index}")

    def read_frame(self):
        ok, frame = self.cap.read()
        if ok:
            self._tick_fps()
        return ok, frame

    def release(self):
        self.cap.release()


class NetworkStreamSource(CameraSource):
    """
    RTSP/IP camera — a network stream that can drop mid-session.
    Includes automatic reconnect logic (the "phone call that can drop"
    case), unlike local devices which don't need it.
    """

    def __init__(self, url: str, max_retries: int = 5, retry_delay: float = 2.0):
        super().__init__()
        self.url = url
        self.max_retries = max_retries
        self.retry_delay = retry_delay
        self.cap = None
        self._connect()

    def _connect(self):
        self.cap = cv2.VideoCapture(self.url)
        if not self.cap.isOpened():
            raise RuntimeError(f"Could not open network stream: {self.url}")

    def read_frame(self):
        ok, frame = self.cap.read()
        if ok:
            self._tick_fps()
            return ok, frame

        # Dropped — attempt reconnect rather than failing immediately.
        for attempt in range(self.max_retries):
            time.sleep(self.retry_delay)
            try:
                self.cap.release()
                self._connect()
                ok, frame = self.cap.read()
                if ok:
                    self._tick_fps()
                    return ok, frame
            except RuntimeError:
                continue
        return False, None

    def release(self):
        if self.cap is not None:
            self.cap.release()


class VideoFileSource(CameraSource):
    """Recorded video file — like a landline, doesn't randomly disconnect."""

    def __init__(self, path: str):
        super().__init__()
        self.cap = cv2.VideoCapture(path)
        if not self.cap.isOpened():
            raise RuntimeError(f"Could not open video file: {path}")

    def read_frame(self):
        ok, frame = self.cap.read()
        if ok:
            self._tick_fps()
        return ok, frame

    def release(self):
        self.cap.release()


class ImageFolderSource(CameraSource):
    """A folder of images, played back like a frame sequence."""

    def __init__(self, folder: str, extensions=(".jpg", ".jpeg", ".png")):
        super().__init__()
        self.paths = []
        for ext in extensions:
            self.paths.extend(sorted(glob.glob(str(Path(folder) / f"*{ext}"))))
        if not self.paths:
            raise RuntimeError(f"No images found in folder: {folder}")
        self._idx = 0

    def read_frame(self):
        if self._idx >= len(self.paths):
            return False, None
        frame = cv2.imread(self.paths[self._idx])
        self._idx += 1
        if frame is not None:
            self._tick_fps()
            return True, frame
        return False, None

    def release(self):
        pass  # nothing to release


def create_camera_source(source_type: str, source_path: str) -> CameraSource:
    """
    Factory — the single entry point Phase 8/9 use. They never construct
    a specific CameraSource subclass directly.
    """
    source_type = source_type.lower()

    if source_type in ("webcam", "usb"):
        return LocalDeviceSource(device_index=source_path)
    elif source_type in ("rtsp", "ip"):
        return NetworkStreamSource(url=source_path)
    elif source_type == "video":
        return VideoFileSource(path=source_path)
    elif source_type == "folder":
        return ImageFolderSource(folder=source_path)
    else:
        raise ValueError(f"Unknown source_type: {source_type}")
