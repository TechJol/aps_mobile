# Практический отчет: ML-приоритизация тестов aps_mobile

## Цель

Реализовать прототип применения методов машинного обучения для автоматизации тестирования приложения `aps_mobile`: модель анализирует измененные файлы проекта и ранжирует тесты по предполагаемой релевантности.

## Объект исследования

`aps_mobile` - Flutter-приложение с feature-first архитектурой. Основные модули:

- `auth` - авторизация и учетные данные;
- `payment` - платежи и подписки;
- `income` - операции доходов/расходов;
- `menu` - транзакции, справочники, отчеты;
- `operation` - фильтрация и группировка операций;
- `account` - счета и балансы;
- `core` - сеть, тема, маршрутизация, общие виджеты.

## Реализованный ML pipeline

1. `scripts/build_ml_dataset.py` формирует обучающую выборку из пар `измененный файл - тест`.
2. `scripts/ml_test_utils.py` извлекает признаки:
   - совпадение feature-модуля;
   - совпадение архитектурного слоя;
   - лексическая близость путей;
   - число общих токенов;
   - ручной бизнес-приоритет теста;
   - тип теста: unit/widget/integration;
   - принадлежность измененного файла к `core` или `feature`.
3. `scripts/train_test_prioritizer.py` обучает две модели:
   - Logistic Regression;
   - Random Forest.
4. `scripts/predict_tests_ml.py` применяет лучшую модель и сохраняет:
   - `scripts/out/prioritized_tests_ml.csv`;
   - `scripts/out/prioritized_tests_ml.txt`.

## Датасет

Источник тестов: `scripts/baseline_test_inventory.csv`.

Результат генерации:

- исходных Dart-файлов: 297;
- тестов в inventory: 12;
- строк датасета: 3564;
- релевантных пар: 449;
- нерелевантных пар: 3115.

## Результаты обучения

Лучшая модель: `Random Forest`.

Классификационные метрики:

| Модель | Accuracy | Precision | Recall | Average Precision | ROC AUC |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | 0.9360 | 0.6647 | 0.9911 | 0.9641 | 0.9948 |
| Random Forest | 0.9405 | 0.6810 | 0.9911 | 0.9701 | 0.9958 |

Метрики ранжирования на тестовом split:

| Подход | Precision@3 | Precision@5 | Recall@3 | Recall@5 | APFD-like |
|---|---:|---:|---:|---:|---:|
| ML Random Forest | 0.1462 | 0.1244 | 0.3269 | 0.3298 | 0.2662 |
| Baseline heuristic | 0.1474 | 0.1244 | 0.3287 | 0.3298 | 0.2665 |

Важно: близость ML и baseline объясняется малым количеством тестов и тем, что начальная разметка строится на структурных признаках проекта. Для диссертации это фиксируется как ограничение эксперимента и основание для дальнейшего накопления истории CI.

## Демонстрационный сценарий

Файл `scripts/example_changed_files.txt`:

```text
lib/src/feature/payment/presentation/cubit/payment_cubit.dart
lib/src/feature/auth/data/repositories/auth_repo_impl.dart
lib/src/core/network/auth_interceptor.dart
```

ML-модель выбрала первые тесты:

1. `test/unit/feature/auth/auth_cubit_test.dart`
2. `test/unit/feature/auth/credential_cubit_test.dart`
3. `test/unit/feature/payment/payment_cubit_test.dart`
4. `test/unit/core/theme/theme_cubit_test.dart`
5. `test/widget/feature/pages/pages_widget_smoke_test.dart`
6. `test/unit/feature/account/account_balance_calculator_test.dart`
7. `test/unit/feature/income/income_cubit_test.dart`
8. `test/unit/feature/menu/menu_cubit_test.dart`

## Проверка тестами

Selective ML run:

- команда: `flutter test` по 8 выбранным ML тест-файлам;
- результат: 27 тестов;
- failures: 0.

Full control run:

- команда: `flutter test test/unit test/widget test/widget_test.dart`;
- результат: 37 тестов;
- failures: 0.

## Вывод

Практическая часть показывает рабочий прототип автоматизации тестирования: ML-модель строит приоритет запуска тестов на основе изменений в коде и характеристик тестов. Подход не заменяет полный регрессионный прогон, но позволяет запускать наиболее вероятно затронутые тесты первыми и использовать результат как основу для CI/CD оптимизации.
