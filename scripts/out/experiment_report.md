# ML Experiment Report

## Purpose

Автоматизированный эксперимент проверяет применение ML-приоритизации тестов для Flutter-проекта `aps_mobile`.

## Pipeline

| Step | Status | Duration, s | Log |
|---|---|---:|---|
| build_dataset | passed | 0.46 | `scripts/out/experiment_logs/01_build_dataset.log` |
| train_model | passed | 1.93 | `scripts/out/experiment_logs/02_train_model.log` |
| run_scenarios | passed | 59.47 | `scripts/out/experiment_logs/03_run_scenarios.log` |

## Dataset

- Rows: 3564
- Positive pairs: 457
- Negative pairs: 3107
- Unique changed files: 297
- Unique tests: 12

## Model Training

| Model | Accuracy | Precision | Recall | Average Precision | ROC AUC |
|---|---:|---:|---:|---:|---:|
| logistic_regression | 0.9416 | 0.6890 | 0.9912 | 0.9476 | 0.9909 |
| random_forest | 0.9618 | 0.7703 | 1.0000 | 0.9830 | 0.9975 |

Best model by Average Precision: `random_forest`.

## Scenario Experiment

- Top-K: 5
- Flutter tests executed: yes

| ID | Category | Approach | Precision | Hit-rate | Expected hits | Test files | Test cases | Duration, s | Status |
|---|---|---|---:|---:|---:|---:|---:|---:|---|
| S01 | auth | ml | 0.4000 | 1.0000 | 2/2 | 5 | 16 | 6.17 | passed |
| S01 | auth | baseline | 0.4000 | 1.0000 | 2/2 | 5 | 16 | 4.28 | passed |
| S02 | payment | ml | 0.4000 | 1.0000 | 2/2 | 5 | 13 | 5.10 | passed |
| S02 | payment | baseline | 0.2000 | 0.5000 | 1/2 | 5 | 16 | 4.73 | passed |
| S03 | income | ml | 0.2000 | 1.0000 | 1/1 | 5 | 13 | 5.06 | passed |
| S03 | income | baseline | 0.2000 | 1.0000 | 1/1 | 5 | 16 | 4.13 | passed |
| S04 | menu | ml | 0.2000 | 0.5000 | 1/2 | 5 | 13 | 5.40 | passed |
| S04 | menu | baseline | 0.2000 | 0.5000 | 1/2 | 5 | 16 | 4.11 | passed |
| S05 | core/network | ml | 0.6000 | 1.0000 | 3/3 | 5 | 14 | 4.44 | passed |
| S05 | core/network | baseline | 0.4000 | 0.6667 | 2/3 | 5 | 14 | 4.93 | passed |
| S06 | routes/widgets | ml | 0.6000 | 1.0000 | 3/3 | 5 | 15 | 5.29 | passed |
| S06 | routes/widgets | baseline | 0.2000 | 0.3333 | 1/3 | 5 | 13 | 4.57 | passed |

## Aggregate Scenario Results

| Approach | Avg precision | Avg hit-rate | Expected hits | Avg duration, s |
|---|---:|---:|---:|---:|
| baseline | 0.2667 | 0.6667 | 8/13 | 4.46 |
| ml | 0.4000 | 0.9167 | 12/13 | 5.24 |

## Conclusion

Все сценарные test runs завершились успешно.
ML-подход показывает преимущество на инфраструктурных сценариях `core/network` и `routes/widgets`, где простая baseline-эвристика выбирает меньше ожидаемых тестов.

## Generated Artifacts

- Dataset: `scripts/out/test_pairs_dataset.csv`
- Training metrics: `scripts/out/ml_training_metrics.csv`
- Scenario summary: `scripts/out/scenarios/scenario_summary.csv`
- Scenario test runs: `scripts/out/scenarios/scenario_test_runs.csv`
- Detailed scenario report: `scripts/out/scenarios/scenario_report.md`
- Test logs: `scripts/out/scenarios/test_logs/`
