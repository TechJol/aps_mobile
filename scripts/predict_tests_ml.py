#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

import joblib

from ml_test_utils import build_prediction_frame, load_inventory


def read_changed_files(path: Path) -> list[str]:
    if not path.exists():
        return []
    return [
        line.strip()
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.strip() and not line.strip().startswith("#")
    ]


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Predict and rank Flutter tests with a trained ML model."
    )
    parser.add_argument("--changed-files", required=True)
    parser.add_argument("--inventory", default="scripts/baseline_test_inventory.csv")
    parser.add_argument("--model", default="scripts/out/test_prioritizer_model.joblib")
    parser.add_argument("--output-txt", default="scripts/out/prioritized_tests_ml.txt")
    parser.add_argument("--output-csv", default="scripts/out/prioritized_tests_ml.csv")
    parser.add_argument("--top-k", type=int, default=40)
    args = parser.parse_args()

    changed_files = read_changed_files(Path(args.changed_files))
    inventory = load_inventory(Path(args.inventory))
    if not changed_files:
        selected = inventory[["path"]].drop_duplicates().copy()
        selected["score"] = 1.0
        selected["matched_changed_file"] = "fallback_all_tests"
    else:
        bundle = joblib.load(args.model)
        model = bundle["model"]
        feature_columns = bundle["feature_columns"]
        pairs = build_prediction_frame(changed_files, inventory)
        pairs["score"] = model.predict_proba(pairs[feature_columns])[:, 1]
        selected = (
            pairs.sort_values("score", ascending=False)
            .groupby("test_path", as_index=False)
            .first()
            .sort_values("score", ascending=False)
            .rename(
                columns={
                    "test_path": "path",
                    "changed_file": "matched_changed_file",
                }
            )
        )

    top_k = max(1, args.top_k)
    selected = selected.head(top_k)
    output_csv = Path(args.output_csv)
    output_txt = Path(args.output_txt)
    output_csv.parent.mkdir(parents=True, exist_ok=True)
    selected.to_csv(output_csv, index=False)
    output_txt.write_text(
        "\n".join(selected["path"].tolist()) + "\n",
        encoding="utf-8",
    )

    print(f"Changed files: {len(changed_files)}")
    print(f"Selected tests: {len(selected)}")
    print(f"CSV: {output_csv.as_posix()}")
    print(f"TXT: {output_txt.as_posix()}")
    for _, row in selected.iterrows():
        print(f" - {row['path']} ({row['score']:.4f})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
