#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

import joblib
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    accuracy_score,
    average_precision_score,
    classification_report,
    precision_score,
    recall_score,
    roc_auc_score,
)
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

from ml_test_utils import FEATURE_COLUMNS


def precision_at_k(group: pd.DataFrame, k: int) -> float:
    top = group.sort_values("score", ascending=False).head(k)
    if top.empty:
        return 0.0
    return float(top["label"].sum() / len(top))


def recall_at_k(group: pd.DataFrame, k: int) -> float:
    relevant = group["label"].sum()
    if relevant == 0:
        return 0.0
    top = group.sort_values("score", ascending=False).head(k)
    return float(top["label"].sum() / relevant)


def apfd_like(group: pd.DataFrame) -> float:
    ordered = group.sort_values("score", ascending=False).reset_index(drop=True)
    relevant_positions = [index + 1 for index, label in enumerate(ordered["label"]) if label == 1]
    n = len(ordered)
    m = len(relevant_positions)
    if n == 0 or m == 0:
        return 0.0
    return float(1 - (sum(relevant_positions) / (n * m)) + (1 / (2 * n)))


def evaluate_ranking(frame: pd.DataFrame, score_column: str) -> dict[str, float]:
    scored = frame.copy()
    if score_column != "score":
        scored["score"] = scored[score_column]
    grouped = scored.groupby("changed_file", group_keys=False)
    return {
        "precision_at_3": grouped.apply(lambda g: precision_at_k(g, 3), include_groups=False).mean(),
        "precision_at_5": grouped.apply(lambda g: precision_at_k(g, 5), include_groups=False).mean(),
        "recall_at_3": grouped.apply(lambda g: recall_at_k(g, 3), include_groups=False).mean(),
        "recall_at_5": grouped.apply(lambda g: recall_at_k(g, 5), include_groups=False).mean(),
        "apfd_like": grouped.apply(apfd_like, include_groups=False).mean(),
    }


def write_report(
    path: Path,
    model_name: str,
    metrics: dict[str, float | str],
    ranking_metrics: dict[str, float],
    baseline_ranking_metrics: dict[str, float],
    report_text: str,
) -> None:
    lines = [
        "# ML Test Prioritizer Training Report",
        "",
        f"Best model: `{model_name}`",
        "",
        "## Classification Metrics",
        "",
    ]
    for key, value in metrics.items():
        if isinstance(value, float):
            lines.append(f"- {key}: {value:.4f}")
        else:
            lines.append(f"- {key}: {value}")

    lines.extend(["", "## Ranking Metrics (ML)", ""])
    for key, value in ranking_metrics.items():
        lines.append(f"- {key}: {value:.4f}")

    lines.extend(["", "## Ranking Metrics (Baseline Heuristic)", ""])
    for key, value in baseline_ranking_metrics.items():
        lines.append(f"- {key}: {value:.4f}")

    lines.extend(["", "## Classification Report", "", "```text", report_text.strip(), "```", ""])
    path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Train ML models for test prioritization.")
    parser.add_argument("--dataset", default="scripts/out/test_pairs_dataset.csv")
    parser.add_argument("--model-output", default="scripts/out/test_prioritizer_model.joblib")
    parser.add_argument("--metrics-output", default="scripts/out/ml_training_metrics.csv")
    parser.add_argument("--report-output", default="scripts/out/ml_training_report.md")
    args = parser.parse_args()

    dataset_path = Path(args.dataset)
    dataset = pd.read_csv(dataset_path)
    if dataset.empty:
        raise ValueError(f"Dataset is empty: {dataset_path}")

    x = dataset[FEATURE_COLUMNS]
    y = dataset["label"]
    x_train, x_test, y_train, y_test = train_test_split(
        x,
        y,
        test_size=0.25,
        random_state=42,
        stratify=y,
    )

    candidates = {
        "logistic_regression": Pipeline(
            [
                ("scaler", StandardScaler()),
                ("model", LogisticRegression(max_iter=1000, class_weight="balanced")),
            ]
        ),
        "random_forest": RandomForestClassifier(
            n_estimators=250,
            max_depth=8,
            min_samples_leaf=2,
            random_state=42,
            class_weight="balanced",
        ),
    }

    rows: list[dict[str, float | str]] = []
    best_name = ""
    best_model = None
    best_average_precision = -1.0
    best_probabilities = None

    for name, model in candidates.items():
        model.fit(x_train, y_train)
        probabilities = model.predict_proba(x_test)[:, 1]
        predictions = (probabilities >= 0.5).astype(int)
        average_precision = average_precision_score(y_test, probabilities)
        row = {
            "model": name,
            "accuracy": accuracy_score(y_test, predictions),
            "precision": precision_score(y_test, predictions, zero_division=0),
            "recall": recall_score(y_test, predictions, zero_division=0),
            "average_precision": average_precision,
            "roc_auc": roc_auc_score(y_test, probabilities),
        }
        rows.append(row)
        if average_precision > best_average_precision:
            best_average_precision = average_precision
            best_name = name
            best_model = model
            best_probabilities = probabilities

    if best_model is None or best_probabilities is None:
        raise RuntimeError("No model was trained.")

    test_frame = dataset.loc[x_test.index].copy()
    test_frame["score"] = best_probabilities
    test_frame["baseline_score"] = (
        (test_frame["same_feature"] * 0.60)
        + (test_frame["token_jaccard"] * 0.30)
        + ((test_frame["manual_priority"] / 5.0) * 0.10)
    )
    ranking_metrics = evaluate_ranking(test_frame, "score")
    baseline_ranking_metrics = evaluate_ranking(test_frame, "baseline_score")
    report_text = classification_report(
        y_test,
        (best_probabilities >= 0.5).astype(int),
        zero_division=0,
    )

    model_output = Path(args.model_output)
    model_output.parent.mkdir(parents=True, exist_ok=True)
    joblib.dump(
        {
            "model": best_model,
            "model_name": best_name,
            "feature_columns": FEATURE_COLUMNS,
        },
        model_output,
    )

    metrics_output = Path(args.metrics_output)
    pd.DataFrame(rows).to_csv(metrics_output, index=False)
    write_report(
        Path(args.report_output),
        best_name,
        next(row for row in rows if row["model"] == best_name),
        ranking_metrics,
        baseline_ranking_metrics,
        report_text,
    )

    print(f"Dataset: {dataset_path.as_posix()}")
    print(f"Best model: {best_name}")
    print(f"Model output: {model_output.as_posix()}")
    print(f"Metrics output: {metrics_output.as_posix()}")
    print(f"Report output: {args.report_output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
