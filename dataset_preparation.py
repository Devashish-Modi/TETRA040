"""
dataset_preparation.py

PHASE 4: Dataset Collection
Project: AI-Powered Intelligent Animal Detection, Identification & Smart Monitoring System
Role: ML Lead

Purpose
-------
This module handles acquisition, validation, and organization of raw animal/human
image data into a clean, YOLO-ready folder structure. It is designed to run
entirely on free tools (Kaggle API, Roboflow free tier, local filesystem) with
zero paid services.

Design principles followed (per project engineering rules):
    - Object-Oriented Programming
    - Type hints throughout
    - Logging instead of print()
    - Config-driven behavior
    - Defensive exception handling
    - Modular, testable methods (no monolithic scripts)

Usage
-----
    from dataset_preparation import DatasetManager

    manager = DatasetManager(root_dir="datasets/raw", output_dir="datasets/organized")
    manager.validate_images()
    manager.report_class_distribution()
    manager.build_yolo_structure(class_names=["human", "cow", "dog", ...])
"""

from __future__ import annotations

import json
import logging
import os
import shutil
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional

import cv2

# ---------------------------------------------------------------------------
# Logging configuration
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
)
logger = logging.getLogger("DatasetPreparation")


# ---------------------------------------------------------------------------
# Config dataclass
# ---------------------------------------------------------------------------
@dataclass
class DatasetConfig:
    """
    Centralized configuration for dataset preparation.

    Keeping this as a dataclass (instead of scattering magic numbers/strings
    through the code) means every future teammate or future-you can see all
    tunable behavior in one place.
    """
    valid_extensions: tuple = (".jpg", ".jpeg", ".png", ".bmp")
    min_width: int = 64          # images smaller than this are almost always unusable
    min_height: int = 64
    train_split: float = 0.70
    val_split: float = 0.20
    test_split: float = 0.10
    seed: int = 42
    class_names: List[str] = field(default_factory=list)


# ---------------------------------------------------------------------------
# Core class
# ---------------------------------------------------------------------------
class DatasetManager:
    """
    Handles the full Phase 4 workflow:
        1. Scan raw collected images
        2. Validate them (corrupt / too-small / unreadable files)
        3. Report class distribution (to catch imbalance early)
        4. Reorganize into YOLO-style train/val/test folders
    """

    def __init__(
        self,
        root_dir: str,
        output_dir: str,
        config: Optional[DatasetConfig] = None,
    ) -> None:
        """
        Parameters
        ----------
        root_dir : str
            Path to the raw dataset, expected to contain one subfolder per class,
            e.g. raw/cow/, raw/human/, raw/dog/ ...
        output_dir : str
            Path where the cleaned, split YOLO-ready dataset will be written.
        config : DatasetConfig, optional
            Configuration object. If omitted, sensible defaults are used.
        """
        self.root_dir = Path(root_dir)
        self.output_dir = Path(output_dir)
        self.config = config or DatasetConfig()

        if not self.root_dir.exists():
            # Fail loudly and early rather than silently producing an empty dataset.
            raise FileNotFoundError(
                f"Raw dataset directory not found: {self.root_dir}. "
                f"Create it and place class subfolders inside before running this."
            )

        logger.info("DatasetManager initialized with root=%s output=%s", root_dir, output_dir)

    # ------------------------------------------------------------------
    def _discover_classes(self) -> List[str]:
        """
        Auto-detects class subfolders under root_dir.
        Returns a sorted list of class names for reproducibility across runs.
        """
        classes = sorted(
            [d.name for d in self.root_dir.iterdir() if d.is_dir()]
        )
        if not classes:
            raise ValueError(
                f"No class subfolders found under {self.root_dir}. "
                f"Expected structure: {self.root_dir}/<class_name>/*.jpg"
            )
        logger.info("Discovered %d classes: %s", len(classes), classes)
        return classes

    # ------------------------------------------------------------------
    def validate_images(self) -> Dict[str, List[str]]:
        """
        Scans every image under root_dir and flags:
            - unreadable / corrupt files (cv2 fails to decode them)
            - images smaller than the configured minimum resolution

        Returns
        -------
        dict with keys "corrupt" and "too_small", each a list of file paths.

        Why this matters: a single corrupt file can crash a training run hours
        in (tf.data / YOLO dataloaders often fail hard on bad images), so we
        catch this at collection time, not training time.
        """
        corrupt_files: List[str] = []
        too_small_files: List[str] = []
        total_checked = 0

        for class_dir in self.root_dir.iterdir():
            if not class_dir.is_dir():
                continue
            for img_path in class_dir.iterdir():
                if img_path.suffix.lower() not in self.config.valid_extensions:
                    continue
                total_checked += 1
                try:
                    img = cv2.imread(str(img_path))
                    if img is None:
                        corrupt_files.append(str(img_path))
                        continue
                    h, w = img.shape[:2]
                    if w < self.config.min_width or h < self.config.min_height:
                        too_small_files.append(str(img_path))
                except Exception as exc:  # noqa: BLE001 - we want to log ANY failure here
                    logger.warning("Failed to read %s: %s", img_path, exc)
                    corrupt_files.append(str(img_path))

        logger.info(
            "Validation complete: %d images checked, %d corrupt, %d too small",
            total_checked, len(corrupt_files), len(too_small_files),
        )
        return {"corrupt": corrupt_files, "too_small": too_small_files}

    # ------------------------------------------------------------------
    def report_class_distribution(self) -> Dict[str, int]:
        """
        Counts valid images per class and warns if imbalance exceeds a 3:1 ratio
        between the largest and smallest class (see Phase 4 math note: skewed
        gradients bias the model toward majority classes).
        """
        counts: Dict[str, int] = {}
        for class_dir in self.root_dir.iterdir():
            if not class_dir.is_dir():
                continue
            n_images = len(
                [f for f in class_dir.iterdir() if f.suffix.lower() in self.config.valid_extensions]
            )
            counts[class_dir.name] = n_images

        if counts:
            max_class = max(counts, key=counts.get)
            min_class = min(counts, key=counts.get)
            max_n, min_n = counts[max_class], counts[min_class]
            ratio = max_n / max(min_n, 1)

            logger.info("Class distribution: %s", counts)
            if ratio > 3:
                logger.warning(
                    "Class imbalance detected: '%s' (%d) vs '%s' (%d), ratio=%.1f:1. "
                    "Consider augmentation or targeted collection for minority classes.",
                    max_class, max_n, min_class, min_n, ratio,
                )
        return counts

    # ------------------------------------------------------------------
    def build_yolo_structure(self) -> None:
        """
        Splits each class's validated images into train/val/test and writes
        them into the YOLO-conventional folder layout:

            output_dir/
                images/train/, images/val/, images/test/
                labels/train/, labels/val/, labels/test/   (labels populated in Phase 5)

        Splitting is done per-class so that class proportions are preserved
        across train/val/test (stratified split) rather than split globally,
        which would risk a rare class disappearing entirely from validation.
        """
        import random
        random.seed(self.config.seed)

        classes = self._discover_classes()
        self.config.class_names = classes

        for split in ("train", "val", "test"):
            (self.output_dir / "images" / split).mkdir(parents=True, exist_ok=True)
            (self.output_dir / "labels" / split).mkdir(parents=True, exist_ok=True)

        for class_name in classes:
            class_dir = self.root_dir / class_name
            images = sorted(
                [f for f in class_dir.iterdir() if f.suffix.lower() in self.config.valid_extensions]
            )
            random.shuffle(images)

            n = len(images)
            n_train = int(n * self.config.train_split)
            n_val = int(n * self.config.val_split)
            # remainder goes to test, avoids rounding losing/gaining an image

            splits = {
                "train": images[:n_train],
                "val": images[n_train:n_train + n_val],
                "test": images[n_train + n_val:],
            }

            for split_name, files in splits.items():
                dest_dir = self.output_dir / "images" / split_name
                for f in files:
                    # Prefix filename with class name to avoid collisions when
                    # multiple classes happen to share an original filename.
                    dest_name = f"{class_name}_{f.name}"
                    try:
                        shutil.copy2(f, dest_dir / dest_name)
                    except Exception as exc:  # noqa: BLE001
                        logger.error("Failed to copy %s -> %s: %s", f, dest_dir, exc)

            logger.info(
                "Class '%s': %d train, %d val, %d test",
                class_name, len(splits["train"]), len(splits["val"]), len(splits["test"]),
            )

        # Persist class list so Phase 5 (annotation) and Phase 6 (training)
        # reference the exact same class order without re-deriving it.
        class_map_path = self.output_dir / "class_names.json"
        with open(class_map_path, "w") as f:
            json.dump(classes, f, indent=4)
        logger.info("Saved class map to %s", class_map_path)


# ---------------------------------------------------------------------------
# Script entry point
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    # Example run - adjust paths to your actual raw collection location.
    manager = DatasetManager(root_dir="datasets/raw", output_dir="datasets/organized")

    validation_report = manager.validate_images()
    if validation_report["corrupt"]:
        logger.warning("Corrupt files found (remove before proceeding): %s", validation_report["corrupt"])

    manager.report_class_distribution()
    manager.build_yolo_structure()
