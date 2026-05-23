# ML Test Prioritizer Training Report

Best model: `random_forest`

## Classification Metrics

- model: random_forest
- accuracy: 0.9618
- precision: 0.7703
- recall: 1.0000
- average_precision: 0.9830
- roc_auc: 0.9975

## Ranking Metrics (ML)

- precision_at_3: 0.1556
- precision_at_5: 0.1348
- recall_at_3: 0.3415
- recall_at_5: 0.3415
- apfd_like: 0.2745

## Ranking Metrics (Baseline Heuristic)

- precision_at_3: 0.1510
- precision_at_5: 0.1348
- recall_at_3: 0.3339
- recall_at_5: 0.3415
- apfd_like: 0.2595

## Classification Report

```text
precision    recall  f1-score   support

           0       1.00      0.96      0.98       777
           1       0.77      1.00      0.87       114

    accuracy                           0.96       891
   macro avg       0.89      0.98      0.92       891
weighted avg       0.97      0.96      0.96       891
```
