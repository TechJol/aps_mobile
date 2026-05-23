# Сценарный эксперимент ML-приоритизации тестов

## Сценарии изменений

| ID | Категория | Описание | Измененных файлов | Ожидаемых тестов |
|---|---|---|---:|---:|
| S01 | auth | Изменение логики авторизации | 2 | 2 |
| S02 | payment | Изменение платежного сценария | 2 | 2 |
| S03 | income | Изменение формы доходов и расходов | 2 | 1 |
| S04 | menu | Изменение меню и транзакций | 2 | 2 |
| S05 | core/network | Изменение сетевого слоя и токенов | 2 | 3 |
| S06 | routes/widgets | Изменение маршрутов и общих виджетов | 2 | 3 |

## Сводные результаты

| ID | Подход | Top-K | Precision | Recall/Hit-rate | Найдено ожидаемых | Файлов тестов | Test cases | Время, c | Статус |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| S01 | ml | 5 | 0.4000 | 1.0000 | 2 | 5 | 16 | 6.17 | passed |
| S01 | baseline | 5 | 0.4000 | 1.0000 | 2 | 5 | 16 | 4.28 | passed |
| S02 | ml | 5 | 0.4000 | 1.0000 | 2 | 5 | 13 | 5.10 | passed |
| S02 | baseline | 5 | 0.2000 | 0.5000 | 1 | 5 | 16 | 4.73 | passed |
| S03 | ml | 5 | 0.2000 | 1.0000 | 1 | 5 | 13 | 5.06 | passed |
| S03 | baseline | 5 | 0.2000 | 1.0000 | 1 | 5 | 16 | 4.13 | passed |
| S04 | ml | 5 | 0.2000 | 0.5000 | 1 | 5 | 13 | 5.40 | passed |
| S04 | baseline | 5 | 0.2000 | 0.5000 | 1 | 5 | 16 | 4.11 | passed |
| S05 | ml | 5 | 0.6000 | 1.0000 | 3 | 5 | 14 | 4.44 | passed |
| S05 | baseline | 5 | 0.4000 | 0.6667 | 2 | 5 | 14 | 4.93 | passed |
| S06 | ml | 5 | 0.6000 | 1.0000 | 3 | 5 | 15 | 5.29 | passed |
| S06 | baseline | 5 | 0.2000 | 0.3333 | 1 | 5 | 13 | 4.57 | passed |

## Детализация по сценариям

### S01: Изменение логики авторизации

Измененные файлы:
- `lib/src/feature/auth/presentation/cubit/auth/auth_cubit.dart`
- `lib/src/feature/auth/data/repositories/auth_repo_impl.dart`

**ML**
- Запущено файлов тестов: 5
- Test cases: 16
- Время: 6.17 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/feature/auth/auth_cubit_test.dart` (score=0.9999, expected=yes)
  - 2. `test/unit/feature/auth/credential_cubit_test.dart` (score=0.9999, expected=yes)
  - 3. `test/unit/feature/pages/all_pages_constructor_smoke_test.dart` (score=0.0029, expected=no)
  - 4. `test/widget_test.dart` (score=0.0025, expected=no)
  - 5. `test/widget/feature/pages/pages_widget_smoke_test.dart` (score=0.0025, expected=no)
- Вывод: Выбранный набор покрыл все ожидаемые тесты сценария и успешно прошел.

**BASELINE**
- Запущено файлов тестов: 5
- Test cases: 16
- Время: 4.28 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/feature/auth/auth_cubit_test.dart` (score=5.0000, expected=yes)
  - 2. `test/unit/feature/auth/credential_cubit_test.dart` (score=4.0000, expected=yes)
  - 3. `test/unit/feature/income/income_cubit_test.dart` (score=3.0000, expected=no)
  - 4. `test/unit/feature/menu/menu_cubit_test.dart` (score=2.0000, expected=no)
  - 5. `test/unit/feature/payment/payment_cubit_test.dart` (score=1.0000, expected=no)
- Вывод: Выбранный набор покрыл все ожидаемые тесты сценария и успешно прошел.

### S02: Изменение платежного сценария

Измененные файлы:
- `lib/src/feature/payment/presentation/cubit/payment_cubit.dart`
- `lib/src/feature/payment/data/repositories/payment_repository_impl.dart`

**ML**
- Запущено файлов тестов: 5
- Test cases: 13
- Время: 5.10 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/feature/payment/payment_cubit_test.dart` (score=0.9999, expected=yes)
  - 2. `test/unit/feature/pages/all_pages_constructor_smoke_test.dart` (score=0.0029, expected=no)
  - 3. `test/widget_test.dart` (score=0.0025, expected=no)
  - 4. `test/widget/feature/pages/pages_widget_smoke_test.dart` (score=0.0025, expected=yes)
  - 5. `test/unit/feature/account/account_balance_calculator_test.dart` (score=0.0009, expected=no)
- Вывод: Выбранный набор покрыл все ожидаемые тесты сценария и успешно прошел.

**BASELINE**
- Запущено файлов тестов: 5
- Test cases: 16
- Время: 4.73 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/feature/payment/payment_cubit_test.dart` (score=5.0000, expected=yes)
  - 2. `test/unit/feature/auth/auth_cubit_test.dart` (score=4.0000, expected=no)
  - 3. `test/unit/feature/income/income_cubit_test.dart` (score=3.0000, expected=no)
  - 4. `test/unit/feature/menu/menu_cubit_test.dart` (score=2.0000, expected=no)
  - 5. `test/unit/feature/auth/credential_cubit_test.dart` (score=1.0000, expected=no)
- Вывод: Выбранный набор частично покрыл ожидаемые тесты; требуется расширение признаков или увеличение Top-K.

### S03: Изменение формы доходов и расходов

Измененные файлы:
- `lib/src/feature/income/presentation/cubit/income_cubit.dart`
- `lib/src/feature/income/data/repositories/income_repo_impl.dart`

**ML**
- Запущено файлов тестов: 5
- Test cases: 13
- Время: 5.06 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/feature/income/income_cubit_test.dart` (score=0.9998, expected=yes)
  - 2. `test/unit/feature/pages/all_pages_constructor_smoke_test.dart` (score=0.0029, expected=no)
  - 3. `test/widget_test.dart` (score=0.0025, expected=no)
  - 4. `test/widget/feature/pages/pages_widget_smoke_test.dart` (score=0.0025, expected=no)
  - 5. `test/unit/feature/account/account_balance_calculator_test.dart` (score=0.0009, expected=no)
- Вывод: Выбранный набор покрыл все ожидаемые тесты сценария и успешно прошел.

**BASELINE**
- Запущено файлов тестов: 5
- Test cases: 16
- Время: 4.13 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/feature/income/income_cubit_test.dart` (score=5.0000, expected=yes)
  - 2. `test/unit/feature/auth/auth_cubit_test.dart` (score=4.0000, expected=no)
  - 3. `test/unit/feature/menu/menu_cubit_test.dart` (score=3.0000, expected=no)
  - 4. `test/unit/feature/payment/payment_cubit_test.dart` (score=2.0000, expected=no)
  - 5. `test/unit/feature/auth/credential_cubit_test.dart` (score=1.0000, expected=no)
- Вывод: Выбранный набор покрыл все ожидаемые тесты сценария и успешно прошел.

### S04: Изменение меню и транзакций

Измененные файлы:
- `lib/src/feature/menu/presentation/cubit/menu_cubit.dart`
- `lib/src/feature/menu/data/repositories/menu_repo_impl.dart`

**ML**
- Запущено файлов тестов: 5
- Test cases: 13
- Время: 5.40 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/feature/menu/menu_cubit_test.dart` (score=0.9998, expected=yes)
  - 2. `test/unit/feature/pages/all_pages_constructor_smoke_test.dart` (score=0.0029, expected=no)
  - 3. `test/widget_test.dart` (score=0.0025, expected=no)
  - 4. `test/widget/feature/pages/pages_widget_smoke_test.dart` (score=0.0025, expected=no)
  - 5. `test/unit/feature/account/account_balance_calculator_test.dart` (score=0.0009, expected=no)
- Вывод: Выбранный набор частично покрыл ожидаемые тесты; требуется расширение признаков или увеличение Top-K.

**BASELINE**
- Запущено файлов тестов: 5
- Test cases: 16
- Время: 4.11 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/feature/menu/menu_cubit_test.dart` (score=5.0000, expected=yes)
  - 2. `test/unit/feature/auth/auth_cubit_test.dart` (score=4.0000, expected=no)
  - 3. `test/unit/feature/income/income_cubit_test.dart` (score=3.0000, expected=no)
  - 4. `test/unit/feature/payment/payment_cubit_test.dart` (score=2.0000, expected=no)
  - 5. `test/unit/feature/auth/credential_cubit_test.dart` (score=1.0000, expected=no)
- Вывод: Выбранный набор частично покрыл ожидаемые тесты; требуется расширение признаков или увеличение Top-K.

### S05: Изменение сетевого слоя и токенов

Измененные файлы:
- `lib/src/core/network/auth_interceptor.dart`
- `lib/src/core/network/dio_client.dart`

**ML**
- Запущено файлов тестов: 5
- Test cases: 14
- Время: 4.44 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/feature/auth/credential_cubit_test.dart` (score=0.9914, expected=yes)
  - 2. `test/unit/feature/auth/auth_cubit_test.dart` (score=0.9898, expected=yes)
  - 3. `test/unit/feature/payment/payment_cubit_test.dart` (score=0.9590, expected=yes)
  - 4. `test/unit/core/theme/theme_cubit_test.dart` (score=0.9492, expected=no)
  - 5. `test/unit/feature/account/account_balance_calculator_test.dart` (score=0.6425, expected=no)
- Вывод: Выбранный набор покрыл все ожидаемые тесты сценария и успешно прошел.

**BASELINE**
- Запущено файлов тестов: 5
- Test cases: 14
- Время: 4.93 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/core/theme/theme_cubit_test.dart` (score=5.0000, expected=no)
  - 2. `test/unit/feature/auth/auth_cubit_test.dart` (score=4.0000, expected=yes)
  - 3. `test/unit/feature/auth/credential_cubit_test.dart` (score=3.0000, expected=yes)
  - 4. `test/widget_test.dart` (score=2.0000, expected=no)
  - 5. `test/unit/feature/income/income_cubit_test.dart` (score=1.0000, expected=no)
- Вывод: Выбранный набор частично покрыл ожидаемые тесты; требуется расширение признаков или увеличение Top-K.

### S06: Изменение маршрутов и общих виджетов

Измененные файлы:
- `lib/src/core/utils/routes/on_generate_route.dart`
- `lib/src/core/widgets/custom_app_bar.dart`

**ML**
- Запущено файлов тестов: 5
- Test cases: 15
- Время: 5.29 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/widget_test.dart` (score=0.8921, expected=yes)
  - 2. `test/widget/feature/pages/pages_widget_smoke_test.dart` (score=0.8862, expected=yes)
  - 3. `test/unit/feature/pages/all_pages_constructor_smoke_test.dart` (score=0.8287, expected=yes)
  - 4. `test/unit/core/theme/theme_cubit_test.dart` (score=0.4520, expected=no)
  - 5. `test/unit/feature/operation/operation_filter_test.dart` (score=0.3813, expected=no)
- Вывод: Выбранный набор покрыл все ожидаемые тесты сценария и успешно прошел.

**BASELINE**
- Запущено файлов тестов: 5
- Test cases: 13
- Время: 4.57 c
- Статус: passed
- Выбранные тесты:
  - 1. `test/unit/core/theme/theme_cubit_test.dart` (score=5.0000, expected=no)
  - 2. `test/widget_test.dart` (score=4.0000, expected=yes)
  - 3. `test/unit/feature/auth/auth_cubit_test.dart` (score=3.0000, expected=no)
  - 4. `test/unit/feature/income/income_cubit_test.dart` (score=2.0000, expected=no)
  - 5. `test/unit/feature/menu/menu_cubit_test.dart` (score=1.0000, expected=no)
- Вывод: Выбранный набор частично покрыл ожидаемые тесты; требуется расширение признаков или увеличение Top-K.
