#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

import pandas as pd
from PIL import Image, ImageDraw, ImageFont


ML_COLOR = "#3B82F6"
BASELINE_COLOR = "#94A3B8"
ACCENT_COLOR = "#10B981"
GRID_COLOR = "#E5E7EB"
TEXT_COLOR = "#111827"
BG_COLOR = "#FFFFFF"


def font(size: int) -> ImageFont.ImageFont:
    return ImageFont.load_default(size=size)


def text_size(draw: ImageDraw.ImageDraw, text: str, fnt: ImageFont.ImageFont) -> tuple[int, int]:
    box = draw.textbbox((0, 0), text, font=fnt)
    return box[2] - box[0], box[3] - box[1]


def draw_centered(
    draw: ImageDraw.ImageDraw,
    xy: tuple[float, float],
    text: str,
    fnt: ImageFont.ImageFont,
    fill: str = TEXT_COLOR,
) -> None:
    width, height = text_size(draw, text, fnt)
    draw.text((xy[0] - width / 2, xy[1] - height / 2), text, font=fnt, fill=fill)


def save_chart(image: Image.Image, path: Path) -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path)
    return path


def draw_title(draw: ImageDraw.ImageDraw, title: str, width: int) -> None:
    draw_centered(draw, (width / 2, 32), title, font(18))


def draw_grouped_bar_chart(
    title: str,
    labels: list[str],
    series: list[tuple[str, list[float], str]],
    output_path: Path,
    y_max: float | None = None,
    y_label: str = "",
    value_suffix: str = "",
) -> Path:
    width, height = 1100, 620
    margin_left, margin_right = 90, 40
    margin_top, margin_bottom = 85, 95
    plot_w = width - margin_left - margin_right
    plot_h = height - margin_top - margin_bottom
    y_max = y_max or max(max(values) for _, values, _ in series) * 1.15

    image = Image.new("RGB", (width, height), BG_COLOR)
    draw = ImageDraw.Draw(image)
    draw_title(draw, title, width)
    if y_label:
        draw.text((18, margin_top + plot_h / 2 - 10), y_label, font=font(12), fill=TEXT_COLOR)

    for tick in range(6):
        value = y_max * tick / 5
        y = margin_top + plot_h - (value / y_max) * plot_h
        draw.line((margin_left, y, width - margin_right, y), fill=GRID_COLOR, width=1)
        draw.text((margin_left - 58, y - 7), f"{value:.1f}", font=font(11), fill=TEXT_COLOR)

    group_w = plot_w / len(labels)
    bar_w = min(42, group_w / (len(series) + 1.2))
    for group_index, label in enumerate(labels):
        group_center = margin_left + group_w * group_index + group_w / 2
        for series_index, (_, values, color) in enumerate(series):
            offset = (series_index - (len(series) - 1) / 2) * (bar_w + 10)
            value = values[group_index]
            bar_h = (value / y_max) * plot_h if y_max else 0
            x0 = group_center + offset - bar_w / 2
            y0 = margin_top + plot_h - bar_h
            x1 = group_center + offset + bar_w / 2
            y1 = margin_top + plot_h
            draw.rectangle((x0, y0, x1, y1), fill=color)
            value_text = f"{value:.2f}{value_suffix}"
            draw_centered(draw, (group_center + offset, y0 - 12), value_text, font(10))
        draw_centered(draw, (group_center, height - 55), label, font(12))

    legend_x = margin_left
    legend_y = height - 28
    for name, _, color in series:
        draw.rectangle((legend_x, legend_y, legend_x + 16, legend_y + 16), fill=color)
        draw.text((legend_x + 22, legend_y), name, font=font(12), fill=TEXT_COLOR)
        legend_x += 150

    draw.rectangle(
        (margin_left, margin_top, width - margin_right, margin_top + plot_h),
        outline="#CBD5E1",
        width=1,
    )
    return save_chart(image, output_path)


def figure_pipeline(output_dir: Path) -> Path:
    path = output_dir / "fig_01_ml_pipeline.png"
    width, height = 1300, 360
    image = Image.new("RGB", (width, height), BG_COLOR)
    draw = ImageDraw.Draw(image)
    draw_title(draw, "ML test prioritization pipeline", width)

    steps = [
        "Changed\nfiles",
        "Feature\nextraction",
        "ML model\ntraining",
        "Prioritized\ntests",
        "Flutter\ntest run",
        "Reports\nCSV",
    ]
    box_w, box_h = 150, 82
    gap = 55
    start_x = (width - (len(steps) * box_w + (len(steps) - 1) * gap)) / 2
    y = 155
    for index, label in enumerate(steps):
        x = start_x + index * (box_w + gap)
        color = ML_COLOR if index in {2, 3} else "#DBEAFE"
        draw.rounded_rectangle((x, y, x + box_w, y + box_h), radius=12, fill=color, outline="#1E40AF", width=2)
        for line_index, line in enumerate(label.split("\n")):
            draw_centered(draw, (x + box_w / 2, y + 30 + line_index * 22), line, font(14), fill=TEXT_COLOR)
        if index < len(steps) - 1:
            arrow_y = y + box_h / 2
            draw.line((x + box_w + 8, arrow_y, x + box_w + gap - 8, arrow_y), fill="#334155", width=3)
            draw.polygon(
                [
                    (x + box_w + gap - 8, arrow_y),
                    (x + box_w + gap - 20, arrow_y - 7),
                    (x + box_w + gap - 20, arrow_y + 7),
                ],
                fill="#334155",
            )
    return save_chart(image, path)


def figure_model_metrics(metrics: pd.DataFrame, output_dir: Path) -> Path:
    columns = ["accuracy", "precision", "recall", "average_precision", "roc_auc"]
    labels = ["Accuracy", "Precision", "Recall", "AvgPrecision", "ROC AUC"]
    metrics = metrics.set_index("model")
    return draw_grouped_bar_chart(
        title="Model quality comparison",
        labels=labels,
        series=[
            ("LogReg", [float(metrics.loc["logistic_regression", column]) for column in columns], BASELINE_COLOR),
            ("RandomForest", [float(metrics.loc["random_forest", column]) for column in columns], ML_COLOR),
        ],
        output_path=output_dir / "fig_02_model_metrics.png",
        y_max=1.05,
        y_label="value",
    )


def figure_hit_rate(summary: pd.DataFrame, output_dir: Path) -> Path:
    pivot = summary.pivot(index="scenario_id", columns="approach", values="hit_rate")
    labels = pivot.index.tolist()
    return draw_grouped_bar_chart(
        title="Hit-rate by change scenario",
        labels=labels,
        series=[
            ("Baseline", pivot["baseline"].astype(float).tolist(), BASELINE_COLOR),
            ("ML", pivot["ml"].astype(float).tolist(), ML_COLOR),
        ],
        output_path=output_dir / "fig_03_hit_rate_by_scenario.png",
        y_max=1.05,
        y_label="hit-rate",
    )


def figure_expected_hits(summary: pd.DataFrame, output_dir: Path) -> Path:
    aggregate = summary.groupby("approach").agg(
        expected_hits=("expected_hits", "sum"),
        expected_total=("expected_total", "sum"),
    )
    total = int(aggregate.loc["ml", "expected_total"])
    return draw_grouped_bar_chart(
        title="Found expected tests",
        labels=["Total"],
        series=[
            ("Baseline", [float(aggregate.loc["baseline", "expected_hits"])], BASELINE_COLOR),
            ("ML", [float(aggregate.loc["ml", "expected_hits"])], ML_COLOR),
        ],
        output_path=output_dir / "fig_04_expected_hits_total.png",
        y_max=total + 1,
        y_label="tests",
    )


def figure_duration(summary: pd.DataFrame, output_dir: Path) -> Path:
    pivot = summary.pivot(index="scenario_id", columns="approach", values="duration_s")
    labels = pivot.index.tolist()
    return draw_grouped_bar_chart(
        title="Selected test execution time",
        labels=labels,
        series=[
            ("Baseline", pivot["baseline"].astype(float).tolist(), BASELINE_COLOR),
            ("ML", pivot["ml"].astype(float).tolist(), ML_COLOR),
        ],
        output_path=output_dir / "fig_05_duration_by_scenario.png",
        y_label="seconds",
    )


def figure_test_cases(summary: pd.DataFrame, output_dir: Path) -> Path:
    pivot = summary.pivot(index="scenario_id", columns="approach", values="test_case_count")
    labels = pivot.index.tolist()
    return draw_grouped_bar_chart(
        title="Executed test cases",
        labels=labels,
        series=[
            ("Baseline", pivot["baseline"].astype(float).tolist(), BASELINE_COLOR),
            ("ML", pivot["ml"].astype(float).tolist(), ML_COLOR),
        ],
        output_path=output_dir / "fig_06_test_cases_by_scenario.png",
        y_label="test cases",
    )


def write_figures_markdown(paths: list[Path], output_path: Path) -> None:
    captions = {
        "fig_01_ml_pipeline.png": "Рисунок 1. Pipeline ML-приоритизации тестов: от измененных файлов до отчетов эксперимента.",
        "fig_02_model_metrics.png": "Рисунок 2. Сравнение качества моделей Logistic Regression и Random Forest.",
        "fig_03_hit_rate_by_scenario.png": "Рисунок 3. Сравнение hit-rate ML и baseline по сценариям изменений.",
        "fig_04_expected_hits_total.png": "Рисунок 4. Общее количество найденных ожидаемых тестов: ML против baseline.",
        "fig_05_duration_by_scenario.png": "Рисунок 5. Время выполнения выбранных тестов по сценариям.",
        "fig_06_test_cases_by_scenario.png": "Рисунок 6. Количество выполненных test cases по сценариям.",
    }
    lines = ["# Рисунки для практической части диссертации", ""]
    for path in paths:
        lines.extend(
            [
                f"## {captions[path.name]}",
                "",
                f"Файл: `{path.as_posix()}`",
                "",
            ]
        )
    output_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate dissertation figures from ML experiment outputs.")
    parser.add_argument("--metrics", default="scripts/out/ml_training_metrics.csv")
    parser.add_argument("--scenario-summary", default="scripts/out/scenarios/scenario_summary.csv")
    parser.add_argument("--output-dir", default="scripts/out/figures")
    parser.add_argument("--markdown-output", default="scripts/dissertation_figures.md")
    args = parser.parse_args()

    metrics = pd.read_csv(args.metrics)
    summary = pd.read_csv(args.scenario_summary)
    output_dir = Path(args.output_dir)

    paths = [
        figure_pipeline(output_dir),
        figure_model_metrics(metrics, output_dir),
        figure_hit_rate(summary, output_dir),
        figure_expected_hits(summary, output_dir),
        figure_duration(summary, output_dir),
        figure_test_cases(summary, output_dir),
    ]
    write_figures_markdown(paths, Path(args.markdown_output))

    print("Generated figures:")
    for path in paths:
        print(f" - {path.as_posix()}")
    print(f"Markdown: {args.markdown_output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
