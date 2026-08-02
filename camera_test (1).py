"""
camera_test.py

Quick standalone check: confirms OpenCV can access your laptop's webcam.
This is NOT the full Phase 7 camera integration module - it's a fast sanity
check you can run right now, before Phase 6 (training) is done, to confirm
your hardware/drivers/OpenCV install all work together.

Run:
    pip install opencv-python --break-system-packages
    python camera_test.py

Controls:
    Press 'q' to quit the preview window.
"""

import cv2
import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(message)s")
logger = logging.getLogger("CameraTest")


def test_webcam(camera_index: int = 0) -> None:
    """
    Opens the laptop's default webcam and displays a live preview.

    Parameters
    ----------
    camera_index : int
        0 is almost always the built-in laptop webcam. If you have an
        external USB camera plugged in too, try 1 if 0 doesn't work.
    """
    cap = cv2.VideoCapture(camera_index)

    if not cap.isOpened():
        logger.error(
            "Could not open camera at index %d. Try index 1, check OS camera "
            "permissions for your terminal/IDE, or confirm no other app is using it.",
            camera_index,
        )
        return

    width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
    height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
    fps = cap.get(cv2.CAP_PROP_FPS)
    logger.info("Camera opened successfully: %dx%d @ %.1f FPS", width, height, fps)

    frame_count = 0
    try:
        while True:
            ret, frame = cap.read()
            if not ret:
                logger.warning("Failed to read frame from camera - stream may have dropped.")
                break

            frame_count += 1
            cv2.putText(
                frame, f"Frame: {frame_count} | Press 'q' to quit",
                (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2,
            )
            cv2.imshow("Laptop Camera Test", frame)

            if cv2.waitKey(1) & 0xFF == ord("q"):
                logger.info("Quit key pressed. Closing camera.")
                break
    finally:
        cap.release()
        cv2.destroyAllWindows()
        logger.info("Camera released. Total frames captured: %d", frame_count)


if __name__ == "__main__":
    test_webcam(camera_index=0)
