"""
test_annotation_validator.py

Automated tests for Phase 5 (annotation_validator.py).

Builds a tiny synthetic YOLO-structured dataset (images + label .txt files)
with deliberately injected problems, to confirm the validator catches every
category of issue it claims to catch.

Run with:
    pip install pytest opencv-python numpy --break-system-packages
    pytest test_annotation_validator.py -v
"""

from pathlib import Path

import cv2
import numpy as np
import pytest

from annotation_validator import AnnotationValidator


CLASS_NAMES = ["cow", "dog", "human"]


@pytest.fixture
def synthetic_yolo_dataset(tmp_path):
    """
    Builds:
        images/train/img1.jpg, img2.jpg, img3.jpg   (3 images)
        labels/train/img1.txt   -> valid label
        labels/train/img2.txt   -> malformed (wrong token count)
        (img3.txt is intentionally MISSING -> missing_labels case)
        labels/train/orphan.txt -> label with no matching image -> orphaned_labels case
    Also creates matching empty val/ and test/ folders since the validator expects them.
    """
    dataset_dir = tmp_path / "organized"

    for split in ("train", "val", "test"):
        (dataset_dir / "images" / split).mkdir(parents=True)
        (dataset_dir / "labels" / split).mkdir(parents=True)

    img = np.full((100, 100, 3), 128, dtype=np.uint8)
    for name in ("img1", "img2", "img3"):
        cv2.imwrite(str(dataset_dir / "images" / "train" / f"{name}.jpg"), img)

    # Valid label: class_id 0 (cow), normalized coords all within [0,1]
    (dataset_dir / "labels" / "train" / "img1.txt").write_text("0 0.5 0.5 0.2 0.3\n")

    # Malformed: only 3 tokens instead of 5
    (dataset_dir / "labels" / "train" / "img2.txt").write_text("0 0.5 0.5\n")

    # img3.txt deliberately not created -> triggers missing_labels

    # Orphaned label with no matching image
    (dataset_dir / "labels" / "train" / "orphan.txt").write_text("1 0.5 0.5 0.1 0.1\n")

    return dataset_dir


def test_missing_and_orphaned_labels_detected(synthetic_yolo_dataset):
    validator = AnnotationValidator(dataset_dir=str(synthetic_yolo_dataset), class_names=CLASS_NAMES)
    report = validator.validate_split("train")

    assert "img3" in report["missing_labels"]
    assert "orphan" in report["orphaned_labels"]


def test_malformed_line_detected(synthetic_yolo_dataset):
    validator = AnnotationValidator(dataset_dir=str(synthetic_yolo_dataset), class_names=CLASS_NAMES)
    report = validator.validate_split("train")

    assert any("img2.txt" in item for item in report["malformed_lines"])


def test_valid_label_produces_no_false_positives(synthetic_yolo_dataset):
    validator = AnnotationValidator(dataset_dir=str(synthetic_yolo_dataset), class_names=CLASS_NAMES)
    report = validator.validate_split("train")

    assert not any("img1.txt" in item for item in report["malformed_lines"])
    assert not any("img1.txt" in item for item in report["invalid_class_ids"])
    assert not any("img1.txt" in item for item in report["out_of_range_coords"])


def test_invalid_class_id_detected(synthetic_yolo_dataset):
    # Inject a label with an out-of-range class_id (99, but only 3 classes exist: 0,1,2)
    bad_label = synthetic_yolo_dataset / "labels" / "train" / "img1.txt"
    bad_label.write_text("99 0.5 0.5 0.2 0.3\n")

    validator = AnnotationValidator(dataset_dir=str(synthetic_yolo_dataset), class_names=CLASS_NAMES)
    report = validator.validate_split("train")

    assert any("class_id=99" in item for item in report["invalid_class_ids"])


def test_out_of_range_coords_detected(synthetic_yolo_dataset):
    # Inject a label with a coordinate > 1.0, which is invalid for normalized YOLO format
    bad_label = synthetic_yolo_dataset / "labels" / "train" / "img1.txt"
    bad_label.write_text("0 1.5 0.5 0.2 0.3\n")

    validator = AnnotationValidator(dataset_dir=str(synthetic_yolo_dataset), class_names=CLASS_NAMES)
    report = validator.validate_split("train")

    assert any("img1.txt" in item for item in report["out_of_range_coords"])


def test_clean_split_passes_with_zero_issues(tmp_path):
    """A perfectly matched, well-formed split should report zero issues in every category."""
    dataset_dir = tmp_path / "organized"
    for split in ("train", "val", "test"):
        (dataset_dir / "images" / split).mkdir(parents=True)
        (dataset_dir / "labels" / split).mkdir(parents=True)

    img = np.full((100, 100, 3), 128, dtype=np.uint8)
    cv2.imwrite(str(dataset_dir / "images" / "train" / "clean.jpg"), img)
    (dataset_dir / "labels" / "train" / "clean.txt").write_text("0 0.5 0.5 0.2 0.3\n")

    validator = AnnotationValidator(dataset_dir=str(dataset_dir), class_names=CLASS_NAMES)
    report = validator.validate_split("train")

    assert all(len(v) == 0 for v in report.values())
