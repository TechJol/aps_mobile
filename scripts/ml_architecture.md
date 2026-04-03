# ML Test Prioritization Architecture (Scripts)

Goal: rank Flutter tests by risk/impact using project data, then export a prioritized list for CI.

## Data Sources (Minimum Viable)
- `changed_files` from VCS (e.g., git diff)
- `test_history` (pass/fail, duration, last_run)
- `manual_priority` (domain criticality)

Optional
- `code_ownership` (module criticality weight)
- `crash/bug history`

## Data Files (CSV)
- `data/changed_files.csv`
  - columns: `path`
- `data/test_history.csv`
  - columns: `test_id,path,last_result,duration_s,fail_count,run_count,last_run`
- `data/manual_priority.csv`
  - columns: `test_id,priority`
- `data/test_features.csv` (generated)
  - columns: feature vector fields

## Modules
- `collect_changed_files.py`
  - reads VCS diff, writes `data/changed_files.csv`
- `build_test_inventory.py`
  - reads `test/**/*_test.dart`, writes `data/test_inventory.csv`
- `extract_features.py`
  - merges inventory + history + changed files + manual priority
- `train_model.py`
  - trains model (baseline: logistic regression / random forest)
- `predict.py`
  - loads model, outputs prioritized test list
- `evaluate.py`
  - compares baseline vs ML ordering on metrics

## Inference Contract
Input:
- `data/changed_files.csv`
- `data/test_history.csv`
- `data/manual_priority.csv`

Output:
- `out/prioritized_tests.txt` (one path per line)
- `out/prioritized_tests.csv` (with scores)

## Baseline (No ML)
- `predict_tests.py` heuristic scoring using token overlap
- provides baseline ordering for comparison
