#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

import pandas as pd

from ml_test_utils import (
    build_pair_features,
    discover_source_files,
    load_inventory,
    relevance_label,
)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Build a supervised dataset for ML-based Flutter test prioritization."
    )
    parser.add_argument("--inventory", default="scripts/baseline_test_inventory.csv")
    parser.add_argument("--output", default="scripts/out/test_pairs_dataset.csv")
    parser.add_argument("--project-root", default=".")
    args = parser.parse_args()

    root = Path(args.project_root)
    inventory = load_inventory(root / args.inventory)
    source_files = discover_source_files(root)

    rows: list[dict[str, object]] = []
    for source_file in source_files:
        changed_file = source_file.relative_to(root).as_posix()
        for _, test in inventory.iterrows():
            row = build_pair_features(
                changed_file=changed_file,
                test_path=test["path"],
                test_type=test["type"],
                test_feature=test["feature"],
                manual_priority=test["manual_priority"],
            )
            row["label"] = relevance_label(row)
            row["test_id"] = test["test_id"]
            row["scenario"] = test.get("scenario", "")
            rows.append(row)

    dataset = pd.DataFrame(rows)
    output = root / args.output
    output.parent.mkdir(parents=True, exist_ok=True)
    dataset.to_csv(output, index=False)

    positives = int(dataset["label"].sum())
    negatives = int(len(dataset) - positives)
    print(f"Source files: {len(source_files)}")
    print(f"Tests: {len(inventory)}")
    print(f"Dataset rows: {len(dataset)}")
    print(f"Positive pairs: {positives}")
    print(f"Negative pairs: {negatives}")
    print(f"Output: {output.as_posix()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
