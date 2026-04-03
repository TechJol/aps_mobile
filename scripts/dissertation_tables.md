# Dissertation Tables and Figures (Templates)

## Table A: Test Inventory (Baseline, No ML)
Columns:
- `test_id`
- `path`
- `type` (unit/widget/integration)
- `feature`
- `scenario`
- `manual_priority` (1-5)
- `duration_s`
- `flakiness_rate`
- `last_result`
- `notes`

## Table B: Baseline Test Run Summary
Columns:
- `run_id`
- `date`
- `tests_run`
- `failures`
- `pass_rate`
- `total_time_s`
- `time_to_first_failure_s`

## Table C: ML Prioritization Output
Columns:
- `run_id`
- `test_id`
- `score`
- `rank`
- `selected` (yes/no)

## Table D: Comparison of Baseline vs ML
Columns:
- `metric`
- `baseline`
- `ml`
- `delta`

Suggested metrics:
- Time-to-First-Failure
- Failures Found in First N Minutes
- Tests Run Until First Failure
- Total Runtime
- Critical Scenario Coverage

## Figure 1: Test Distribution by Type
- Bar chart: unit vs widget vs integration counts.

## Figure 2: Failures Found Over Time
- Line chart: cumulative failures vs time (baseline vs ML).

## Figure 3: Time-to-First-Failure
- Box plot or bar chart across multiple runs.

## Figure 4: Priority vs Actual Failure Rate
- Scatter plot: manual/ML priority vs failure probability.

## Figure 5: Coverage of Critical Scenarios
- Bar chart: percent of critical tests included in top-N.
