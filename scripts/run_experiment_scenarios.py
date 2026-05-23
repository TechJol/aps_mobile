#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import re
import subprocess
import time
from dataclasses import dataclass, field
from pathlib import Path

import joblib
import pandas as pd

from ml_test_utils import build_prediction_frame, load_inventory
from predict_tests import discover_tests, select_tests


CASE_COUNT_RE = re.compile(r"\+(\d+).*All tests passed")


@dataclass
class Scenario:
    scenario_id: str
    title: str
    category: str
    changed_files: list[str] = field(default_factory=list)
    expected_tests: set[str] = field(default_factory=set)


@dataclass
class TestRunResult:
    selected_files_count: int
    test_case_count: int | None
    duration_s: float
    exit_code: int | None
    status: str
    output_path: str


def read_scenarios(path: Path) -> list[Scenario]:
    scenarios: dict[str, Scenario] = {}
    with path.open(encoding="utf-8", newline="") as handle:
        for row in csv.DictReader(handle):
            scenario_id = row["scenario_id"]
            scenario = scenarios.setdefault(
                scenario_id,
                Scenario(
                    scenario_id=scenario_id,
                    title=row["title"],
                    category=row["category"],
                ),
            )
            scenario.changed_files.append(row["changed_file"])
            scenario.expected_tests.update(
                item.strip()
                for item in row["expected_tests"].split(";")
                if item.strip()
            )
    return list(scenarios.values())


def rank_ml_tests(
    scenario: Scenario,
    inventory: pd.DataFrame,
    model_bundle: dict[str, object],
    top_k: int,
) -> list[tuple[str, float]]:
    pairs = build_prediction_frame(scenario.changed_files, inventory)
    model = model_bundle["model"]
    feature_columns = model_bundle["feature_columns"]
    pairs["score"] = model.predict_proba(pairs[feature_columns])[:, 1]
    ranked = (
        pairs.sort_values("score", ascending=False)
        .groupby("test_path", as_index=False)
        .first()
        .sort_values("score", ascending=False)
        .head(top_k)
    )
    return [(row["test_path"], float(row["score"])) for _, row in ranked.iterrows()]


def rank_baseline_tests(scenario: Scenario, top_k: int) -> list[tuple[str, float]]:
    selected = select_tests(
        all_tests=discover_tests(Path("test")),
        changed_files=scenario.changed_files,
        top_k=top_k,
    )
    score = float(top_k)
    rows: list[tuple[str, float]] = []
    for test_path in selected:
        rows.append((test_path.as_posix(), score))
        score -= 1.0
    return rows


def hit_rate(selected: list[str], expected: set[str]) -> float:
    if not expected:
        return 0.0
    return len(set(selected) & expected) / len(expected)


def precision(selected: list[str], expected: set[str]) -> float:
    if not selected:
        return 0.0
    return len(set(selected) & expected) / len(selected)


def write_changed_files(scenario: Scenario, output_dir: Path) -> Path:
    changed_path = output_dir / "changed_files" / f"{scenario.scenario_id}.txt"
    changed_path.parent.mkdir(parents=True, exist_ok=True)
    changed_path.write_text("\n".join(scenario.changed_files) + "\n", encoding="utf-8")
    return changed_path


def parse_test_case_count(output: str) -> int | None:
    matches = CASE_COUNT_RE.findall(output)
    if matches:
        return int(matches[-1])
    progress_matches = re.findall(r"\+(\d+)", output)
    if progress_matches:
        return int(progress_matches[-1])
    return None


def run_flutter_tests(
    scenario: Scenario,
    approach: str,
    selected_paths: list[str],
    output_dir: Path,
    enabled: bool,
) -> TestRunResult:
    log_path = output_dir / "test_logs" / f"{scenario.scenario_id}_{approach}.log"
    log_path.parent.mkdir(parents=True, exist_ok=True)

    if not enabled:
        log_path.write_text("Test execution disabled. Re-run with --run-tests.\n", encoding="utf-8")
        return TestRunResult(
            selected_files_count=len(selected_paths),
            test_case_count=None,
            duration_s=0.0,
            exit_code=None,
            status="not_run",
            output_path=log_path.as_posix(),
        )

    if not selected_paths:
        log_path.write_text("No tests selected.\n", encoding="utf-8")
        return TestRunResult(
            selected_files_count=0,
            test_case_count=0,
            duration_s=0.0,
            exit_code=0,
            status="passed",
            output_path=log_path.as_posix(),
        )

    started = time.perf_counter()
    completed = subprocess.run(
        ["flutter", "test", *selected_paths],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    duration_s = time.perf_counter() - started
    output = completed.stdout or ""
    log_path.write_text(output, encoding="utf-8")

    return TestRunResult(
        selected_files_count=len(selected_paths),
        test_case_count=parse_test_case_count(output),
        duration_s=duration_s,
        exit_code=completed.returncode,
        status="passed" if completed.returncode == 0 else "failed",
        output_path=log_path.as_posix(),
    )


def scenario_conclusion(row: dict[str, object]) -> str:
    status = row["status"]
    hit_rate_value = float(row["hit_rate"])
    if status != "passed":
        return "Набор выбранных тестов обнаружил проблему или завершился ошибкой запуска."
    if hit_rate_value >= 1.0:
        return "Выбранный набор покрыл все ожидаемые тесты сценария и успешно прошел."
    if hit_rate_value > 0.0:
        return "Выбранный набор частично покрыл ожидаемые тесты; требуется расширение признаков или увеличение Top-K."
    return "Выбранный набор не покрыл ожидаемые тесты; сценарий показывает ограничение текущего подхода."


def write_report(
    scenarios: list[Scenario],
    summary_rows: list[dict[str, object]],
    selection_rows: list[dict[str, object]],
    output_path: Path,
) -> None:
    lines = [
        "# Сценарный эксперимент ML-приоритизации тестов",
        "",
        "## Сценарии изменений",
        "",
        "| ID | Категория | Описание | Измененных файлов | Ожидаемых тестов |",
        "|---|---|---|---:|---:|",
    ]
    for scenario in scenarios:
        lines.append(
            f"| {scenario.scenario_id} | {scenario.category} | {scenario.title} | "
            f"{len(scenario.changed_files)} | {len(scenario.expected_tests)} |"
        )

    lines.extend(
        [
            "",
            "## Сводные результаты",
            "",
            "| ID | Подход | Top-K | Precision | Recall/Hit-rate | Найдено ожидаемых | Файлов тестов | Test cases | Время, c | Статус |",
            "|---|---|---:|---:|---:|---:|---:|---:|---:|---|",
        ]
    )
    for row in summary_rows:
        test_case_count = row["test_case_count"] if row["test_case_count"] is not None else "-"
        lines.append(
            f"| {row['scenario_id']} | {row['approach']} | {row['top_k']} | "
            f"{row['precision']:.4f} | {row['hit_rate']:.4f} | {row['expected_hits']} | "
            f"{row['selected_files_count']} | {test_case_count} | "
            f"{row['duration_s']:.2f} | {row['status']} |"
        )

    lines.extend(["", "## Детализация по сценариям", ""])
    for scenario in scenarios:
        lines.extend([f"### {scenario.scenario_id}: {scenario.title}", ""])
        lines.append("Измененные файлы:")
        for changed_file in scenario.changed_files:
            lines.append(f"- `{changed_file}`")
        lines.append("")
        for approach in ("ml", "baseline"):
            summary = next(
                row
                for row in summary_rows
                if row["scenario_id"] == scenario.scenario_id and row["approach"] == approach
            )
            lines.append(f"**{approach.upper()}**")
            lines.append(
                f"- Запущено файлов тестов: {summary['selected_files_count']}"
            )
            lines.append(
                f"- Test cases: {summary['test_case_count'] if summary['test_case_count'] is not None else 'не измерено'}"
            )
            lines.append(f"- Время: {summary['duration_s']:.2f} c")
            lines.append(f"- Статус: {summary['status']}")
            lines.append("- Выбранные тесты:")
            rows = [
                row
                for row in selection_rows
                if row["scenario_id"] == scenario.scenario_id and row["approach"] == approach
            ]
            for row in rows:
                mark = "yes" if row["is_expected"] else "no"
                lines.append(
                    f"  - {row['rank']}. `{row['test_path']}` "
                    f"(score={row['score']:.4f}, expected={mark})"
                )
            lines.append(f"- Вывод: {scenario_conclusion(summary)}")
            lines.append("")

    output_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Run realistic change scenarios through ML and baseline test prioritizers."
    )
    parser.add_argument("--scenarios", default="scripts/experiment_scenarios.csv")
    parser.add_argument("--inventory", default="scripts/baseline_test_inventory.csv")
    parser.add_argument("--model", default="scripts/out/test_prioritizer_model.joblib")
    parser.add_argument("--output-dir", default="scripts/out/scenarios")
    parser.add_argument("--top-k", type=int, default=5)
    parser.add_argument(
        "--run-tests",
        action="store_true",
        help="Run selected Flutter tests for every scenario and approach.",
    )
    args = parser.parse_args()

    scenarios = read_scenarios(Path(args.scenarios))
    inventory = load_inventory(Path(args.inventory))
    model_bundle = joblib.load(args.model)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    summary_rows: list[dict[str, object]] = []
    selection_rows: list[dict[str, object]] = []

    for scenario in scenarios:
        write_changed_files(scenario, output_dir)
        rankings = {
            "ml": rank_ml_tests(scenario, inventory, model_bundle, args.top_k),
            "baseline": rank_baseline_tests(scenario, args.top_k),
        }
        for approach, ranked in rankings.items():
            selected_paths = [path for path, _ in ranked]
            expected_hits = len(set(selected_paths) & scenario.expected_tests)
            run_result = run_flutter_tests(
                scenario=scenario,
                approach=approach,
                selected_paths=selected_paths,
                output_dir=output_dir,
                enabled=args.run_tests,
            )
            summary_rows.append(
                {
                    "scenario_id": scenario.scenario_id,
                    "title": scenario.title,
                    "category": scenario.category,
                    "approach": approach,
                    "top_k": args.top_k,
                    "precision": precision(selected_paths, scenario.expected_tests),
                    "hit_rate": hit_rate(selected_paths, scenario.expected_tests),
                    "expected_hits": expected_hits,
                    "expected_total": len(scenario.expected_tests),
                    "selected_files_count": run_result.selected_files_count,
                    "test_case_count": run_result.test_case_count,
                    "duration_s": run_result.duration_s,
                    "exit_code": run_result.exit_code,
                    "status": run_result.status,
                    "test_output_path": run_result.output_path,
                    "changed_files": "\n".join(scenario.changed_files),
                    "expected_tests": "\n".join(sorted(scenario.expected_tests)),
                }
            )
            for index, (test_path, score) in enumerate(ranked, start=1):
                selection_rows.append(
                    {
                        "scenario_id": scenario.scenario_id,
                        "title": scenario.title,
                        "category": scenario.category,
                        "approach": approach,
                        "rank": index,
                        "test_path": test_path,
                        "score": score,
                        "is_expected": test_path in scenario.expected_tests,
                    }
                )

    summary_path = output_dir / "scenario_summary.csv"
    selections_path = output_dir / "scenario_selections.csv"
    run_path = output_dir / "scenario_test_runs.csv"
    report_path = output_dir / "scenario_report.md"
    pd.DataFrame(summary_rows).to_csv(summary_path, index=False)
    pd.DataFrame(
        [
            {
                "scenario_id": row["scenario_id"],
                "title": row["title"],
                "category": row["category"],
                "approach": row["approach"],
                "selected_files_count": row["selected_files_count"],
                "test_case_count": row["test_case_count"],
                "duration_s": row["duration_s"],
                "exit_code": row["exit_code"],
                "status": row["status"],
                "test_output_path": row["test_output_path"],
            }
            for row in summary_rows
        ]
    ).to_csv(run_path, index=False)
    pd.DataFrame(selection_rows).to_csv(selections_path, index=False)
    write_report(scenarios, summary_rows, selection_rows, report_path)

    print(f"Scenarios: {len(scenarios)}")
    print(f"Summary: {summary_path.as_posix()}")
    print(f"Test runs: {run_path.as_posix()}")
    print(f"Selections: {selections_path.as_posix()}")
    print(f"Report: {report_path.as_posix()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
