// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Стабильные ключи выбора (не зависят от локали)
enum ViewType { expense, income, all }

enum PeriodType { day, week, month, year }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// текущее состояние фильтров
  ViewType selectedView = ViewType.all;
  PeriodType selectedPeriod = PeriodType.day;

  /// Полные (сырые) сгруппированные данные по статьям за выбранный период/вид
  Map<String, double> groupedData = {};

  // цвета для ТОП-3 и для "Другое"
  static const _topColors = [
    Color(0xFF4600D7), // фиолетовый
    Color(0xFFBC6FF8), // лиловый
    Color(0xFF8385F2), // синий
  ];
  static const _otherColor = Color(0xFF1EBF93); // зелёный для "Другое"

  @override
  void initState() {
    context.read<MenuCubit>().getTransactionsWithAccounts();
    context.read<CredentialCubit>().getUserById();
    super.initState();
  }

  void updateState<T>(T value, void Function(T) updater) =>
      setState(() => updater(value));

  // ---------- Лейблы для enum с учётом текущей локали ----------
  String viewLabel(ViewType v) {
    switch (v) {
      case ViewType.expense:
        return t.home.expenses;
      case ViewType.income:
        return t.home.income;
      case ViewType.all:
        return t.home.all;
    }
  }

  String periodLabel(PeriodType p) {
    switch (p) {
      case PeriodType.day:
        return t.home.day;
      case PeriodType.week:
        return t.home.week;
      case PeriodType.month:
        return t.home.month;
      case PeriodType.year:
        return t.home.year;
    }
  }

  // порядок показа табов периода
  final _periodOptionsOrder = const [
    PeriodType.day,
    PeriodType.week,
    PeriodType.month,
    PeriodType.year,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F7),
        title: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/icons/logo_softkg.png'),
            ),
            Text(
              t.home.appbar,
              style: AppTextStyles.f24w600.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.menu,
                  );
                  if (result == true) {
                    context.read<MenuCubit>().getTransactionsWithAccounts();
                  }
                },
                icon: const Icon(Icons.more_vert_outlined, size: 28),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildHeader(),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildRecentOperationsSection(),
          ),
        ],
      ),
    );
  }

  // ---------------- Header (диаграмма + легенда + фильтры периода) ----------------

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F7),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildTopSection(),
          const SizedBox(height: 15),
          _buildOperationFilters(),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    final state = context.watch<MenuCubit>().state;
    if (state is! MenuTransactionsWithAccountsSuccess) {
      return SizedBox(height: 240, child: Text(t.home.loading));
    }

    // Сырые данные под выбранный период + вид (расход/доход/все)
    groupedData = getGroupedReasonData(
      transactions: state.transactions,
      reasons: state.reasons,
      period: selectedPeriod,
      viewType: selectedView,
    );

    // Берём ТОП-3 и строим данные для пончика (ТОП-3 + "Другое")
    final top3 = _topNEntries(groupedData, 3);
    final chartData = _chartDataFromTop(groupedData, top3);

    // Подготовим цвета (по порядку сегментов chartData)
    final hasOther = chartData.containsKey(t.home.other); // "Другие"
    final colorsForChart = <Color>[
      ..._topColors.take(top3.length),
      if (hasOther) _otherColor,
    ];

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 240,
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 10,
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Заголовок "День/Неделя/..."
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      periodLabel(selectedPeriod),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),

                // Диаграмма / заглушка
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final offset = Tween<Offset>(
                      begin: const Offset(0, 0),
                      end: Offset.zero,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: offset, child: child),
                    );
                  },
                  child:
                      chartData.isEmpty
                          ? SizedBox(
                            key: ValueKey('empty_$selectedPeriod'),
                            height: 140,
                            child: Center(
                              child: Text(
                                t.home.noData,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          : Row(
                            key: ValueKey(
                              'chart_${selectedPeriod}_${chartData.length}_${selectedView.name}',
                            ),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 112,
                                height: 112,
                                child: CustomPaint(
                                  size: const Size(112, 112),
                                  painter: PieChartDynamicPainter(
                                    data: chartData,
                                    colors: colorsForChart,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              _legendFromTopAndOther(top3, hasOther),
                            ],
                          ),
                ),

                const SizedBox(height: 18),

                // ------ Табы периода (inline, без отдельного _PeriodTab) ------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      _periodOptionsOrder.map((p) {
                        final isSelected = selectedPeriod == p;
                        return GestureDetector(
                          onTap: () => _onPeriodTap(p),
                          child: Column(
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color:
                                      isSelected
                                          ? AppColors.primaryColor
                                          : Colors.grey,
                                ),
                                child: Text(periodLabel(p)),
                              ),
                              const SizedBox(height: 6),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                height: 2,
                                width: isSelected ? 24 : 0,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),

        // стрелки смены периода
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: _circleIcon(
            icon: Icons.arrow_back_ios_rounded,
            onTap: () => _changePeriod(false),
          ),
        ),
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: _circleIcon(
            icon: Icons.arrow_forward_ios_rounded,
            onTap: () => _changePeriod(true),
          ),
        ),
      ],
    );
  }

  // ---------------- Переключатели "Расходы / Доходы / Общий" ----------------

  Widget _buildOperationFilters() {
    final options = [ViewType.expense, ViewType.income, ViewType.all];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          options.map((view) {
            final isSelected = selectedView == view;
            final icon =
                view == ViewType.all
                    ? 'assets/images/vector_all.svg'
                    : view == ViewType.income
                    ? 'assets/images/vector_down.svg'
                    : 'assets/images/vector_up.svg';

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedView = view;
                      final s = context.read<MenuCubit>().state;
                      if (s is MenuTransactionsWithAccountsSuccess) {
                        groupedData = getGroupedReasonData(
                          transactions: s.transactions,
                          reasons: s.reasons,
                          period: selectedPeriod,
                          viewType: selectedView,
                        );
                      } else {
                        groupedData = {};
                      }
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: SvgPicture.asset(
                      icon,
                      fit: BoxFit.scaleDown,
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        isSelected ? Colors.white : Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  viewLabel(view),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    fontSize: 16,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  // ---------------- Последние операции ----------------

  Widget _buildRecentOperationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок + "смотреть все"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(t.home.operations, style: AppTextStyles.f20w600),
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.read<MainCubit>().change(4),
                  child: Text(
                    t.home.seeAll,
                    style: AppTextStyles.f14w500.copyWith(
                      color: AppColors.smallTextGreyColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.smallTextGreyColor,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 0.3,
                color: AppColors.smallTextGreyColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state is MenuTransactionsWithAccountsSuccess) {
              final txList = _filterByViewType(
                state.transactions,
                selectedView,
              );
              final partners = state.partners;

              if (txList.isEmpty) {
                return Center(child: Text(t.home.noOperations));
              }

              return Column(
                children: List.generate(txList.length, (index) {
                  final tx = txList[index];
                  final isIncome = tx.transactionType == 'income';
                  final amountText = '${tx.amount} с';

                  final date =
                      DateTime.tryParse(tx.date ?? '') ?? DateTime.now();
                  final formattedDate =
                      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

                  final partnerName =
                      partners
                          .firstWhere(
                            (p) => p.id == tx.partners,
                            orElse: () => PartnersModel(name: t.home.unknown),
                          )
                          .name;

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 400 + index * 100),
                    tween: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ),
                    curve: Curves.easeOut,
                    builder:
                        (context, offset, child) => Transform.translate(
                          offset: offset * 30,
                          child: Opacity(
                            opacity: 1.0 - offset.dy,
                            child: child,
                          ),
                        ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  isIncome
                                      ? const Color(0xFFDFF7E2)
                                      : const Color(0xFFF9DCDC),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isIncome ? Icons.call_received : Icons.north_west,
                              color:
                                  isIncome
                                      ? const Color(0xFF56BC60)
                                      : const Color(0xFFE85445),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(partnerName, style: AppTextStyles.f14w500),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: AppTextStyles.f12w400.copyWith(
                                    color: AppColors.smallTextGreyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${isIncome ? '' : '-'}$amountText',
                            style: AppTextStyles.f16w600.copyWith(
                              color:
                                  isIncome
                                      ? const Color(0xFF56BC60)
                                      : const Color(0xFFE85445),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }

            if (state is MenuLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MenuError) {
              return Center(child: Text('Ошибка: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // ---------------- Вспомогательные методы ----------------

  List<AllTransactionsModel> _filterByViewType(
    List<AllTransactionsModel> transactions,
    ViewType vType,
  ) {
    final sorted = [...transactions]..sort((a, b) {
      final dateA = DateTime.tryParse(a.date ?? '') ?? DateTime.now();
      final dateB = DateTime.tryParse(b.date ?? '') ?? DateTime.now();
      return dateB.compareTo(dateA);
    });

    switch (vType) {
      case ViewType.all:
        return sorted.take(3).toList();
      case ViewType.income:
        return sorted
            .where((tx) => tx.transactionType == 'income')
            .take(3)
            .toList();
      case ViewType.expense:
        return sorted
            .where((tx) => tx.transactionType == 'expense')
            .take(3)
            .toList();
    }
  }

  /// Легенда: ТОП-3 + "Другое" (если есть)
  Widget _legendFromTopAndOther(
    List<MapEntry<String, double>> top3,
    bool hasOther,
  ) {
    final items = <_LegendItemData>[
      for (int i = 0; i < top3.length; i++)
        _LegendItemData(label: top3[i].key, color: _topColors[i]),
      if (hasOther) _LegendItemData(label: t.home.other, color: _otherColor),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 22, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            items
                .map(
                  (it) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: it.color, radius: 5.5),
                        const SizedBox(width: 6),
                        Text(it.label),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _circleIcon({
    IconData? icon,
    Offset? offset,
    required VoidCallback onTap,
  }) {
    return Transform.translate(
      offset: offset ?? Offset.zero,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          padding: const EdgeInsets.all(5),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }

  // единая точка смены периода (используют и табы, и стрелки)
  void _onPeriodTap(PeriodType newPeriod) {
    if (newPeriod == selectedPeriod) return;
    setState(() {
      selectedPeriod = newPeriod;
      final state = context.read<MenuCubit>().state;
      if (state is MenuTransactionsWithAccountsSuccess) {
        groupedData = getGroupedReasonData(
          transactions: state.transactions,
          reasons: state.reasons,
          period: selectedPeriod,
          viewType: selectedView,
        );
      } else {
        groupedData = {};
      }
    });
  }

  void _changePeriod(bool forward) {
    final idx = _periodOptionsOrder.indexOf(selectedPeriod);
    final next =
        forward
            ? (idx + 1) % _periodOptionsOrder.length
            : (idx - 1 + _periodOptionsOrder.length) %
                _periodOptionsOrder.length;
    _onPeriodTap(_periodOptionsOrder[next]);
  }

  /// Построить данные для пончика: ТОП-N + "Другие" (если есть остаток)
  Map<String, double> _chartDataFromTop(
    Map<String, double> original,
    List<MapEntry<String, double>> top,
  ) {
    final res = <String, double>{};
    double topSum = 0;
    for (final e in top) {
      res[e.key] = e.value; // порядок сохраняем
      topSum += e.value;
    }
    final total = original.values.fold(0.0, (s, v) => s + v);
    final rest = total - topSum;
    if (rest > 0.0) res[t.home.other] = rest;
    return res;
  }

  /// Отсортировать по сумме (по убыванию) и взять top N
  List<MapEntry<String, double>> _topNEntries(Map<String, double> data, int n) {
    final entries =
        data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return entries.take(n).toList();
  }

  /// Группировка сумм по статьям с фильтрацией по периоду и виду операции
  Map<String, double> getGroupedReasonData({
    required List<AllTransactionsModel> transactions,
    required List<IncomeExpenseReasons> reasons,
    required PeriodType period,
    required ViewType viewType,
  }) {
    final now = DateTime.now();

    bool isInPeriod(DateTime txDate) {
      switch (period) {
        case PeriodType.day:
          return txDate.day == now.day &&
              txDate.month == now.month &&
              txDate.year == now.year;
        case PeriodType.week:
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          return txDate.isAfter(
                startOfWeek.subtract(const Duration(days: 1)),
              ) &&
              txDate.isBefore(endOfWeek.add(const Duration(days: 1)));
        case PeriodType.month:
          return txDate.month == now.month && txDate.year == now.year;
        case PeriodType.year:
          return txDate.year == now.year;
      }
    }

    // Map<reasonId, reasonName>
    final Map<int, String> reasonNames = {for (var r in reasons) r.id!: r.name};

    // Итоговая группировка: Map<Название статьи, сумма>
    final Map<String, double> grouped = {};

    for (final tx in transactions) {
      final date = DateTime.tryParse(tx.date ?? '');
      if (date == null || tx.incomeExpenseReason == null) continue;
      if (!isInPeriod(date)) continue;

      // фильтр по типу операции
      if (viewType != ViewType.all) {
        final type = viewType == ViewType.income ? 'income' : 'expense';
        if (tx.transactionType != type) continue;
      }

      final reasonId = tx.incomeExpenseReason!;
      final reasonName = reasonNames[reasonId] ?? t.home.other;
      final amount = double.tryParse(tx.amount ?? '0') ?? 0;

      grouped[reasonName] = (grouped[reasonName] ?? 0) + amount;
    }

    return grouped;
  }
}

class _LegendItemData {
  final String label;
  final Color color;
  _LegendItemData({required this.label, required this.color});
}

// ---------------- Рисовальщики пончика ----------------

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9.5
          ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const segments = [
      {'color': Color(0xFF4600D7), 'sweep': 2.0},
      {'color': Color(0xFFBC6FF8), 'sweep': 2.1},
      {'color': Color(0xFF8385F2), 'sweep': 2.18},
    ];
    const gap = 0.27;
    double start = 0;

    for (var seg in segments) {
      paint.color = seg['color'] as Color;
      final sweep = (seg['sweep'] as double) - gap;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += seg['sweep'] as double;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PieChartDynamicPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors;
  PieChartDynamicPainter({required this.data, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9.5
          ..strokeCap = StrokeCap.round;

    final total = data.values.fold(0.0, (sum, value) => sum + value);
    if (total == 0) return;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const gap = 0.27;
    double startAngle = 0.0;

    final segments = data.entries.toList(); // порядок: top3, затем "Другие"

    for (int i = 0; i < segments.length; i++) {
      final value = segments[i].value;
      final sweepAngle = (value / total) * 2 * 3.14159 - gap;

      paint.color = colors[i % colors.length];
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

      startAngle += (value / total) * 2 * 3.14159;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
