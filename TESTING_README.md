# ML Lead Phase Files — Testing Guide

This covers Phases 4 and 5 (files delivered so far). More phases will be added
to this same set as they're completed.

## Files in this package

| File | Phase | Purpose |
|---|---|---|
| `dataset_preparation.py` | 4 | Validates raw images, reports class balance, builds YOLO train/val/test folder structure |
| `annotation_validator.py` | 5 | Validates YOLO label files, converts COCO/VOC annotations to YOLO format |
| `tests/test_dataset_preparation.py` | 4 | Automated tests (no real data needed) |
| `tests/test_annotation_validator.py` | 5 | Automated tests (no real data needed) |

---

## 1. Automated testing (do this first, always)

These tests generate tiny **synthetic** images and labels on the fly, so you
can verify the code logic is correct before you even have your real dataset
downloaded. This is the fastest way to catch bugs.

### Setup (one time)
```bash
pip install pytest opencv-python numpy --break-system-packages
```

### Run all tests
```bash
cd <folder containing dataset_preparation.py, annotation_validator.py, and tests/>
pytest tests/ -v
```

**Expected output:** all tests should show `PASSED`. If anything shows
`FAILED`, that pinpoints exactly which behavior broke and why — read the
assertion error, it tells you the expected vs actual value.

### What each test file actually proves
- `test_dataset_preparation.py`:
  - Corrupt/too-small images are correctly flagged
  - Class counts are correct
  - Train/val/test split math is exactly right (e.g. 10 images → 7/2/1)
  - A missing root directory fails loudly instead of silently doing nothing
- `test_annotation_validator.py`:
  - Missing label files are detected
  - Orphaned label files (no matching image) are detected
  - Malformed label lines (wrong number of values) are detected
  - Out-of-range class IDs and coordinates are detected
  - A perfectly clean dataset reports zero false positives

---

## 2. Manual testing with your OWN real data

Once you've actually collected some images (even just 5-10 per class is
enough to test the pipeline end-to-end):

### Step A — Set up a raw folder
```
datasets/raw/
    cow/       (put some cow images here)
    dog/
    human/
    ... one folder per class
```

### Step B — Run Phase 4 directly
```bash
python dataset_preparation.py
```
This will:
1. Print a validation report (corrupt/too-small files)
2. Print class distribution + warn if imbalance ratio > 3:1
3. Build `datasets/organized/` with `images/train|val|test` and
   `labels/train|val|test` (labels folders will be empty until you annotate)
4. Save `datasets/organized/class_names.json`

**Check it worked:** open `datasets/organized/class_names.json` and confirm
it lists your classes. Spot-check a few images landed in `images/train/`.

### Step C — Annotate a few images
Use LabelImg (free, offline) in YOLO export mode, or export from Roboflow —
save the resulting `.txt` files into the matching
`datasets/organized/labels/train/`, `.../val/`, `.../test/` folders (filename
must match the image filename, e.g. `cow_1.jpg` → `cow_1.txt`).

### Step D — Run Phase 5 directly
```bash
python annotation_validator.py
```
This will validate every split and print a pass/fail report. If it says
`All splits passed annotation validation. Ready for Phase 6.` — you're
correctly set up to move to training.

If it reports issues, fix them in this order (cheapest fixes first):
1. **missing_labels** — annotate the listed images, or move them out of the split if you don't intend to annotate them yet
2. **orphaned_labels** — delete the stray `.txt` file, or add back the matching image if it was accidentally removed
3. **malformed_lines** — open the file at the reported line number, confirm it has exactly 5 space-separated values
4. **invalid_class_ids** — cross-check the class_id against `class_names.json`'s index order
5. **out_of_range_coords** — re-export the annotation; a value outside [0,1] usually means pixel coordinates were saved instead of normalized ones

---

## Notes
- These files have zero paid dependencies — only `opencv-python`, `numpy`, `pytest`, and Python's standard library.
- Everything is designed to run locally or in Colab Free identically.
- More phase files (6: YOLO Training, 7: Camera Integration, 8: Object Detection, 9: Multi-Object Tracking) will be added to this same set as they're completed and approved.
