"""
annotation_validator.py

PHASE 5: Dataset Annotation
Project: AI-Powered Intelligent Animal Detection, Identification & Smart Monitoring System
Role: ML Lead

Purpose
-------
Validates YOLO-format label files against their corresponding images and
provides conversion helpers for annotations coming from other formats
(e.g. COCO JSON, Pascal VOC XML) into YOLO .txt format.

Why this exists: annotation tools (LabelImg, CVAT, Roboflow exports) each have
quirks - off-by-one class indices, out-of-range coordinates, orphaned label
files with no matching image, or images with no label file at all. Catching
these here prevents a training run from crashing hours in, or worse, silently
training on corrupted ground truth.

Design principles followed:
    - Object-Oriented Programming
    - Type hints throughout
    - Logging instead of print()
    - Defensive exception handling
    - Modular, testable methods
"""

from __future__ import annotations

import json
import logging
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Dict, List, Tuple

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
)
logger = logging.getLogger("AnnotationValidator")


class AnnotationValidator:
    """
    Validates a YOLO-format dataset directory of the shape:

        dataset/
            images/train/*.jpg
            labels/train/*.txt
            images/val/*.jpg
            labels/val/*.txt
            ...

    and reports any structural problems before training begins.
    """

    def __init__(self, dataset_dir: str, class_names: List[str]) -> None:
        """
        Parameters
        ----------
        dataset_dir : str
            Root of the YOLO-structured dataset (output of Phase 4's
            DatasetManager.build_yolo_structure()).
        class_names : List[str]
            Ordered list of class names. Index in this list = the class_id
            expected in label files. Must match datasets/organized/class_names.json
            from Phase 4 exactly, or class_ids will silently mean the wrong thing.
        """
        self.dataset_dir = Path(dataset_dir)
        self.class_names = class_names
        self.num_classes = len(class_names)

        if not self.dataset_dir.exists():
            raise FileNotFoundError(f"Dataset directory not found: {self.dataset_dir}")

        logger.info(
            "AnnotationValidator initialized for %s with %d classes",
            dataset_dir, self.num_classes,
        )

    # ------------------------------------------------------------------
    def validate_split(self, split: str) -> Dict[str, List[str]]:
        """
        Validates one split ("train", "val", or "test"). Checks for:
            - images with no matching label file
            - label files with no matching image (orphaned labels)
            - label files with malformed lines (wrong token count)
            - class_id outside the valid [0, num_classes-1] range
            - normalized coordinates outside [0, 1]

        Returns a dict of problem categories -> list of file paths, so issues
        can be reviewed and fixed (or the files excluded) before training.
        """
        images_dir = self.dataset_dir / "images" / split
        labels_dir = self.dataset_dir / "labels" / split

        if not images_dir.exists() or not labels_dir.exists():
            raise FileNotFoundError(
                f"Expected {images_dir} and {labels_dir} to exist for split '{split}'"
            )

        image_stems = {f.stem for f in images_dir.iterdir() if f.is_file()}
        label_stems = {f.stem for f in labels_dir.iterdir() if f.suffix == ".txt"}

        missing_labels = sorted(image_stems - label_stems)
        orphaned_labels = sorted(label_stems - image_stems)

        malformed_lines: List[str] = []
        invalid_class_ids: List[str] = []
        out_of_range_coords: List[str] = []

        for label_file in labels_dir.iterdir():
            if label_file.suffix != ".txt":
                continue
            try:
                with open(label_file, "r") as f:
                    for line_num, line in enumerate(f, start=1):
                        line = line.strip()
                        if not line:
                            continue  # blank lines are harmless, skip
                        tokens = line.split()
                        if len(tokens) != 5:
                            malformed_lines.append(f"{label_file}:{line_num}")
                            continue

                        class_id_str, x, y, w, h = tokens
                        try:
                            class_id = int(class_id_str)
                            coords = [float(x), float(y), float(w), float(h)]
                        except ValueError:
                            malformed_lines.append(f"{label_file}:{line_num}")
                            continue

                        if not (0 <= class_id < self.num_classes):
                            invalid_class_ids.append(f"{label_file}:{line_num} (class_id={class_id})")

                        if any(c < 0.0 or c > 1.0 for c in coords):
                            out_of_range_coords.append(f"{label_file}:{line_num}")

            except Exception as exc:  # noqa: BLE001
                logger.error("Failed to read %s: %s", label_file, exc)
                malformed_lines.append(str(label_file))

        report = {
            "missing_labels": missing_labels,
            "orphaned_labels": orphaned_labels,
            "malformed_lines": malformed_lines,
            "invalid_class_ids": invalid_class_ids,
            "out_of_range_coords": out_of_range_coords,
        }

        total_issues = sum(len(v) for v in report.values())
        if total_issues == 0:
            logger.info("Split '%s': PASSED validation, no issues found", split)
        else:
            logger.warning("Split '%s': %d total issues found - see report", split, total_issues)
            for category, items in report.items():
                if items:
                    logger.warning("  %s: %d (%s%s)", category, len(items),
                                    ", ".join(items[:3]), " ..." if len(items) > 3 else "")

        return report

    # ------------------------------------------------------------------
    def validate_all_splits(self) -> Dict[str, Dict[str, List[str]]]:
        """Runs validate_split() across train/val/test and returns a combined report."""
        return {split: self.validate_split(split) for split in ("train", "val", "test")}

    # ------------------------------------------------------------------
    @staticmethod
    def convert_voc_to_yolo(
        voc_xml_path: str,
        class_names: List[str],
        output_txt_path: str,
    ) -> None:
        """
        Converts a single Pascal VOC XML annotation to a YOLO .txt file.

        VOC stores absolute pixel coordinates (xmin, ymin, xmax, ymax);
        YOLO needs normalized (x_center, y_center, width, height). This
        conversion is the most common source of annotation bugs when mixing
        datasets from different sources, so it is centralized here rather
        than reimplemented ad hoc.
        """
        tree = ET.parse(voc_xml_path)
        root = tree.getroot()

        img_width = int(root.find("size/width").text)
        img_height = int(root.find("size/height").text)

        lines: List[str] = []
        for obj in root.findall("object"):
            class_name = obj.find("name").text
            if class_name not in class_names:
                logger.warning(
                    "Class '%s' in %s not found in class_names list - skipping this object",
                    class_name, voc_xml_path,
                )
                continue
            class_id = class_names.index(class_name)

            bbox = obj.find("bndbox")
            xmin = float(bbox.find("xmin").text)
            ymin = float(bbox.find("ymin").text)
            xmax = float(bbox.find("xmax").text)
            ymax = float(bbox.find("ymax").text)

            x_center = ((xmin + xmax) / 2) / img_width
            y_center = ((ymin + ymax) / 2) / img_height
            width = (xmax - xmin) / img_width
            height = (ymax - ymin) / img_height

            lines.append(f"{class_id} {x_center:.6f} {y_center:.6f} {width:.6f} {height:.6f}")

        with open(output_txt_path, "w") as f:
            f.write("\n".join(lines))

        logger.info("Converted %s -> %s (%d objects)", voc_xml_path, output_txt_path, len(lines))

    # ------------------------------------------------------------------
    @staticmethod
    def convert_coco_to_yolo(
        coco_json_path: str,
        output_labels_dir: str,
    ) -> List[str]:
        """
        Converts a COCO-format annotation JSON into per-image YOLO .txt files.

        COCO stores [x_min, y_min, box_width, box_height] in absolute pixels,
        and class ids as COCO category_ids which do NOT necessarily start at 0
        or match your project's class ordering - remapping to your own
        class_names list is essential and handled here.

        Returns the list of class names in the order that ends up encoded as
        YOLO class_ids (0, 1, 2, ...), so you can save it as your
        class_names.json and keep everything consistent with Phase 4/6.
        """
        with open(coco_json_path, "r") as f:
            coco = json.load(f)

        categories = {cat["id"]: cat["name"] for cat in coco["categories"]}
        # Sort by category id so class_id assignment is deterministic across runs.
        sorted_cat_ids = sorted(categories.keys())
        cat_id_to_class_id = {cat_id: idx for idx, cat_id in enumerate(sorted_cat_ids)}
        class_names_ordered = [categories[cid] for cid in sorted_cat_ids]

        images_by_id = {img["id"]: img for img in coco["images"]}
        output_dir = Path(output_labels_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

        # Group annotations per image so we write one file per image, not per box.
        annotations_by_image: Dict[int, List[str]] = {}
        for ann in coco["annotations"]:
            img = images_by_id.get(ann["image_id"])
            if img is None:
                continue
            img_w, img_h = img["width"], img["height"]
            x_min, y_min, box_w, box_h = ann["bbox"]

            x_center = (x_min + box_w / 2) / img_w
            y_center = (y_min + box_h / 2) / img_h
            norm_w = box_w / img_w
            norm_h = box_h / img_h

            class_id = cat_id_to_class_id[ann["category_id"]]
            line = f"{class_id} {x_center:.6f} {y_center:.6f} {norm_w:.6f} {norm_h:.6f}"
            annotations_by_image.setdefault(ann["image_id"], []).append(line)

        for image_id, lines in annotations_by_image.items():
            img_filename = Path(images_by_id[image_id]["file_name"]).stem
            with open(output_dir / f"{img_filename}.txt", "w") as f:
                f.write("\n".join(lines))

        logger.info(
            "Converted COCO %s -> %d label files in %s (classes: %s)",
            coco_json_path, len(annotations_by_image), output_labels_dir, class_names_ordered,
        )
        return class_names_ordered


# ---------------------------------------------------------------------------
if __name__ == "__main__":
    # Load the class list saved by Phase 4 to guarantee consistent class_id ordering.
    with open("datasets/organized/class_names.json", "r") as f:
        class_names = json.load(f)

    validator = AnnotationValidator(dataset_dir="datasets/organized", class_names=class_names)
    full_report = validator.validate_all_splits()

    total_issues = sum(
        len(items) for split_report in full_report.values() for items in split_report.values()
    )
    if total_issues > 0:
        logger.warning(
            "%d total annotation issues found across all splits. "
            "Fix these before proceeding to Phase 6 (YOLO Training).",
            total_issues,
        )
    else:
        logger.info("All splits passed annotation validation. Ready for Phase 6.")
