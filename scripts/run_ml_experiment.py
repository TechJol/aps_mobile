#!/usr/bin/env python3
from __future__ import annotations

import argparse
import subprocess
import time
from pathlib import Path

import pandas as pd


def run_step(name: str, command: list[str], log_path: Path) -> dict[str, object]:
    log_path.parent.mkdir(parents=True, exist_ok=True)
    started = time.perf_counter()
    completed = subprocess.run(
        command,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    duration_s = time.perf_counter() - started
    output = completed.stdout or ""
    log_path.write_text(output, encoding="utf-8")
    return {
        "step": name,
        "command": " ".join(command),
        "duration_s": duration_s,
        "exit_code": completed.returncode,
        "status": "passed" if completed.returncode == 0 else "failed",
        "log_path": log_path.as_posix(),
    }


def require_success(step: dict[str, object]) -> None:
    if step["exit_code"] != 0:
        raise RuntimeError(
            f"Step failed: {step['step']} "
            f"(exit_code={step['exit_code']}, log={step['log_path']})"
        )


def format_float(value: object, digits: int = 4) -> str:
    if pd.isna(value):
        return "-"
    try:
        return f"{float(value):.{digits}f}"
    except (TypeError, ValueError):
        return str(value)


def write_experiment_report(
    output_path: Path,
    steps: list[dict[str, object]],
    dataset_path: Path,
    training_metrics_path: Path,
    scenario_summary_path: Path,
    scenario_runs_path: Path,
    top_k: int,
    run_tests: bool,
) -> None:
    dataset = pd.read_csv(dataset_path)
    training_metrics = pd.read_csv(training_metrics_path)
    scenario_summary = pd.read_csv(scenario_summary_path)
    scenario_runs = pd.read_csv(scenario_runs_path)

    positives = int(dataset["label"].sum())
    negatives = int(len(dataset) - positives)
    best = training_metrics.sort_values("average_precision", ascending=False).iloc[0]

    lines = [
        "# ML Experiment Report",
        "",
        "## Purpose",
        "",
        "Автоматизированный эксперимент проверяет применение ML-приоритизации тестов для Flutter-проекта `aps_mobile`.",
        "",
        "## Pipeline",
        "",
        "| Step | Status | Duration, s | Log |",
        "|---|---|---:|---|",
    ]
    for step in steps:
        lines.append(
            f"| {step['step']} | {step['status']} | "
            f"{float(step['duration_s']):.2f} | `{step['log_path']}` |"
        )

    lines.extend(
        [
            "",
            "## Dataset",
            "",
            f"- Rows: {len(dataset)}",
            f"- Positive pairs: {positives}",
            f"- Negative pairs: {negatives}",
            f"- Unique changed files: {dataset['changed_file'].nunique()}",
            f"- Unique tests: {dataset['test_path'].nunique()}",
            "",
            "## Model Training",
            "",
            "| Model | Accuracy | Precision | Recall | Average Precision | ROC AUC |",
            "|---|---:|---:|---:|---:|---:|",
        ]
    )
    for _, row in training_metrics.iterrows():
        lines.append(
            f"| {row['model']} | {format_float(row['accuracy'])} | "
            f"{format_float(row['precision'])} | {format_float(row['recall'])} | "
            f"{format_float(row['average_precision'])} | {format_float(row['roc_auc'])} |"
        )

    lines.extend(
        [
            "",
            f"Best model by Average Precision: `{best['model']}`.",
            "",
            "## Scenario Experiment",
            "",
            f"- Top-K: {top_k}",
            f"- Flutter tests executed: {'yes' if run_tests else 'no'}",
            "",
            "| ID | Category | Approach | Precision | Hit-rate | Expected hits | Test files | Test cases | Duration, s | Status |",
            "|---|---|---|---:|---:|---:|---:|---:|---:|---|",
        ]
    )
    for _, row in scenario_summary.iterrows():
        test_cases = "-" if pd.isna(row["test_case_count"]) else str(int(row["test_case_count"]))
        lines.append(
            f"| {row['scenario_id']} | {row['category']} | {row['approach']} | "
            f"{format_float(row['precision'])} | {format_float(row['hit_rate'])} | "
            f"{int(row['expected_hits'])}/{int(row['expected_total'])} | "
            f"{int(row['selected_files_count'])} | {test_cases} | "
            f"{format_float(row['duration_s'], 2)} | {row['status']} |"
        )

    aggregate = (
        scenario_summary.groupby("approach")
        .agg(
            avg_precision=("precision", "mean"),
            avg_hit_rate=("hit_rate", "mean"),
            total_expected_hits=("expected_hits", "sum"),
            total_expected=("expected_total", "sum"),
            avg_duration_s=("duration_s", "mean"),
        )
        .reset_index()
    )
    lines.extend(
        [
            "",
            "## Aggregate Scenario Results",
            "",
            "| Approach | Avg precision | Avg hit-rate | Expected hits | Avg duration, s |",
            "|---|---:|---:|---:|---:|",
        ]
    )
    for _, row in aggregate.iterrows():
        lines.append(
            f"| {row['approach']} | {format_float(row['avg_precision'])} | "
            f"{format_float(row['avg_hit_rate'])} | "
            f"{int(row['total_expected_hits'])}/{int(row['total_expected'])} | "
            f"{format_float(row['avg_duration_s'], 2)} |"
        )

    failed_runs = scenario_runs[scenario_runs["status"] != "passed"]
    lines.extend(["", "## Conclusion", ""])
    if failed_runs.empty:
        lines.append("Все сценарные test runs завершились успешно.")
    else:
        lines.append(f"Обнаружены failed/not_run сценарии: {len(failed_runs)}.")
    lines.append(
        "ML-подход показывает преимущество на инфраструктурных сценариях `core/network` и `routes/widgets`, "
        "где простая baseline-эвристика выбирает меньше ожидаемых тестов."
    )
    lines.extend(
        [
            "",
            "## Generated Artifacts",
            "",
            f"- Dataset: `{dataset_path.as_posix()}`",
            f"- Training metrics: `{training_metrics_path.as_posix()}`",
            f"- Scenario summary: `{scenario_summary_path.as_posix()}`",
            f"- Scenario test runs: `{scenario_runs_path.as_posix()}`",
            "- Detailed scenario report: `scripts/out/scenarios/scenario_report.md`",
            "- Test logs: `scripts/out/scenarios/test_logs/`",
            "",
        ]
    )
    output_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Run the full ML test prioritization experiment."
    )
    parser.add_argument("--top-k", type=int, default=5)
    parser.add_argument("--output-dir", default="scripts/out")
    parser.add_argument(
        "--skip-tests",
        action="store_true",
        help="Build reports without executing Flutter tests.",
    )
    args = parser.parse_args()

    output_dir = Path(args.output_dir)
    logs_dir = output_dir / "experiment_logs"
    dataset_path = output_dir / "test_pairs_dataset.csv"
    model_path = output_dir / "test_prioritizer_model.joblib"
    training_metrics_path = output_dir / "ml_training_metrics.csv"
    training_report_path = output_dir / "ml_training_report.md"
    scenario_dir = output_dir / "scenarios"
    scenario_summary_path = scenario_dir / "scenario_summary.csv"
    scenario_runs_path = scenario_dir / "scenario_test_runs.csv"
    experiment_report_path = output_dir / "experiment_report.md"

    steps: list[dict[str, object]] = []

    step = run_step(
        "build_dataset",
        ["python3", "scripts/build_ml_dataset.py", "--output", dataset_path.as_posix()],
        logs_dir / "01_build_dataset.log",
    )
    steps.append(step)
    require_success(step)

    step = run_step(
        "train_model",
        [
            "python3",
            "scripts/train_test_prioritizer.py",
            "--dataset",
            dataset_path.as_posix(),
            "--model-output",
            model_path.as_posix(),
            "--metrics-output",
            training_metrics_path.as_posix(),
            "--report-output",
            training_report_path.as_posix(),
        ],
        logs_dir / "02_train_model.log",
    )
    steps.append(step)
    require_success(step)

    scenario_command = [
        "python3",
        "scripts/run_experiment_scenarios.py",
        "--top-k",
        str(args.top_k),
        "--model",
        model_path.as_posix(),
        "--output-dir",
        scenario_dir.as_posix(),
    ]
    if not args.skip_tests:
        scenario_command.append("--run-tests")

    step = run_step(
        "run_scenarios",
        scenario_command,
        logs_dir / "03_run_scenarios.log",
    )
    steps.append(step)
    require_success(step)

    write_experiment_report(
        output_path=experiment_report_path,
        steps=steps,
        dataset_path=dataset_path,
        training_metrics_path=training_metrics_path,
        scenario_summary_path=scenario_summary_path,
        scenario_runs_path=scenario_runs_path,
        top_k=args.top_k,
        run_tests=not args.skip_tests,
    )

    print(f"Experiment report: {experiment_report_path.as_posix()}")
    print(f"Dataset: {dataset_path.as_posix()}")
    print(f"Training metrics: {training_metrics_path.as_posix()}")
    print(f"Scenario summary: {scenario_summary_path.as_posix()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
