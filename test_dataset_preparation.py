"""
test_dataset_preparation.py

Automated tests for Phase 4 (dataset_preparation.py).

These tests build a tiny SYNTHETIC dataset on the fly (a few solid-color
images per fake class) so you can verify the script's logic works correctly
WITHOUT needing your real animal dataset downloaded yet. Once your real
dataset exists, you don't need these tests to run the actual script -
these just prove the code itself is correct.

Run with:
    pip install pytest opencv-python numpy --break-system-packages
    pytest test_dataset_preparation.py -v
"""

import json
import shutil
from pathlib import Path

import cv2
import numpy as np
import pytest

from dataset_preparation import DatasetConfig, DatasetManager


@pytest.fixture
def synthetic_raw_dataset(tmp_path):
    """
    Creates a fake raw dataset:
        raw/cow/*.jpg      (10 valid images)
        raw/dog/*.jpg      (10 valid images)
        raw/corrupt_test/  (1 valid + 1 corrupt + 1 too-small image)
    tmp_path is a pytest-provided temporary directory, auto-cleaned after the test.
    """
    raw_dir = tmp_path / "raw"

    for class_name, count in [("cow", 10), ("dog", 10)]:
        class_dir = raw_dir / class_name
        class_dir.mkdir(parents=True)
        for i in range(count):
            img = np.full((120, 120, 3), fill_value=(i * 5) % 255, dtype=np.uint8)
            cv2.imwrite(str(class_dir / f"{class_name}_{i}.jpg"), img)

    # Add an edge-case class with one corrupt and one too-small image
    edge_dir = raw_dir / "edge_case"
    edge_dir.mkdir(parents=True)
    good_img = np.full((100, 100, 3), 128, dtype=np.uint8)
    cv2.imwrite(str(edge_dir / "good.jpg"), good_img)

    tiny_img = np.full((10, 10, 3), 128, dtype=np.uint8)
    cv2.imwrite(str(edge_dir / "tiny.jpg"), tiny_img)

    corrupt_file = edge_dir / "corrupt.jpg"
    corrupt_file.write_bytes(b"not a real image")

    return raw_dir


def test_discover_and_validate_images(synthetic_raw_dataset, tmp_path):
    """Validation should correctly flag the corrupt file and the too-small file."""
    output_dir = tmp_path / "organized"
    manager = DatasetManager(root_dir=str(synthetic_raw_dataset), output_dir=str(output_dir))

    report = manager.validate_images()

    assert any("corrupt.jpg" in f for f in report["corrupt"])
    assert any("tiny.jpg" in f for f in report["too_small"])
    # The 20 good cow/dog images + the 1 good edge_case image should NOT be flagged
    assert not any("good.jpg" in f for f in report["corrupt"] + report["too_small"])


def test_class_distribution_counts_correctly(synthetic_raw_dataset, tmp_path):
    output_dir = tmp_path / "organized"
    manager = DatasetManager(root_dir=str(synthetic_raw_dataset), output_dir=str(output_dir))

    counts = manager.report_class_distribution()

    assert counts["cow"] == 10
    assert counts["dog"] == 10
    assert counts["edge_case"] == 3  # good + tiny + corrupt all count as files present


def test_build_yolo_structure_creates_expected_folders(synthetic_raw_dataset, tmp_path):
    output_dir = tmp_path / "organized"
    manager = DatasetManager(root_dir=str(synthetic_raw_dataset), output_dir=str(output_dir))

    manager.build_yolo_structure()

    for split in ("train", "val", "test"):
        assert (output_dir / "images" / split).exists()
        assert (output_dir / "labels" / split).exists()

    class_map_path = output_dir / "class_names.json"
    assert class_map_path.exists()
    with open(class_map_path) as f:
        classes = json.load(f)
    assert set(classes) == {"cow", "dog", "edge_case"}


def test_split_proportions_are_respected(synthetic_raw_dataset, tmp_path):
    """
    With 10 cow images and default 70/20/10 split, expect 7 train, 2 val, 1 test.
    This confirms the per-class stratified split math is correct.
    """
    output_dir = tmp_path / "organized"
    manager = DatasetManager(root_dir=str(synthetic_raw_dataset), output_dir=str(output_dir))
    manager.build_yolo_structure()

    train_cow = list((output_dir / "images" / "train").glob("cow_*"))
    val_cow = list((output_dir / "images" / "val").glob("cow_*"))
    test_cow = list((output_dir / "images" / "test").glob("cow_*"))

    assert len(train_cow) == 7
    assert len(val_cow) == 2
    assert len(test_cow) == 1


def test_missing_root_dir_raises_clear_error(tmp_path):
    """Should fail loudly and early, not silently produce an empty dataset."""
    with pytest.raises(FileNotFoundError):
        DatasetManager(root_dir=str(tmp_path / "does_not_exist"), output_dir=str(tmp_path / "out"))
