// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String selectedView = 'Общий';
  String selectedPeriod = 'День';

  final viewOptions = const ['Расходы', 'Доходы', 'Общий'];
  final periodOptions = const ['День', 'Неделя', 'Месяц', 'Год'];

  Map<String, double> groupedData = {};

  @override
  void initState() {
    context.read<MenuCubit>().getTransactionsWithAccounts();
    context.read<CredentialCubit>().getUserById();
    super.initState();
  }

  void updateState<T>(T value, void Function(T) updater) =>
      setState(() => updater(value));

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
              'SoftkgPro',
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
      return const SizedBox(height: 240, child: Text('Загрузка...'));
    }

    // Пересчитываем данные под выбранный период
    groupedData = getGroupedReasonData(
      transactions: state.transactions,
      reasons: state.reasons,
      period: selectedPeriod,
    );

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      selectedPeriod,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),

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
                      groupedData.isEmpty
                          ? SizedBox(
                            key: ValueKey('empty_$selectedPeriod'),
                            height: 140,
                            child: const Center(
                              child: Text(
                                'Нет данных за период',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          : Row(
                            key: ValueKey(
                              'chart_${selectedPeriod}_${groupedData.length}',
                            ),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 112,
                                height: 112,
                                child: CustomPaint(
                                  size: const Size(112, 112),
                                  painter: PieChartDynamicPainter(
                                    data: groupedData,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              _legendFromData(groupedData),
                            ],
                          ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      periodOptions.map((p) {
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
                                child: Text(p),
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

  Widget _buildOperationFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          viewOptions.map((view) {
            final isSelected = selectedView == view;
            final icon =
                view == 'Общий'
                    ? 'assets/images/vector_all.svg'
                    : view == 'Доходы'
                    ? 'assets/images/vector_down.svg'
                    : 'assets/images/vector_up.svg';
            return Column(
              children: [
                GestureDetector(
                  onTap: () => updateState(view, (val) => selectedView = val),
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
                  view,
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

  Widget _buildRecentOperationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Операции', style: AppTextStyles.f20w600),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<MainCubit>().change(4);
                  },
                  child: Text(
                    'смотреть все',
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
                return const Center(child: Text('Нет операций'));
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
                            orElse: () => PartnersModel(name: 'Неизвестно'),
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

  List<AllTransactionsModel> _filterByViewType(
    List<AllTransactionsModel> transactions,
    String selectedView,
  ) {
    final sorted = [...transactions]..sort((a, b) {
      final dateA = DateTime.tryParse(a.date ?? '') ?? DateTime.now();
      final dateB = DateTime.tryParse(b.date ?? '') ?? DateTime.now();
      return dateB.compareTo(dateA);
    });

    if (selectedView == 'Общий') {
      return sorted.take(3).toList();
    } else {
      final type = selectedView == 'Доходы' ? 'income' : 'expense';
      return sorted.where((tx) => tx.transactionType == type).take(3).toList();
    }
  }

  Widget _legendFromData(Map<String, double> data) {
    final colors = [
      const Color(0xFF4600D7),
      const Color(0xFFBC6FF8),
      const Color(0xFF8385F2),
      const Color(0xFFFCA12C),
      const Color(0xFF1EBF93),
    ];

    final entries = data.entries.toList();

    return Padding(
      padding: const EdgeInsets.only(top: 22, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(entries.length, (i) {
          final item = entries[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors[i % colors.length],
                  radius: 5.5,
                ),
                const SizedBox(width: 6),
                Text(item.key),
              ],
            ),
          );
        }),
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
  void _onPeriodTap(String newPeriod) {
    if (newPeriod == selectedPeriod) return;
    setState(() {
      selectedPeriod = newPeriod;
      final state = context.read<MenuCubit>().state;
      if (state is MenuTransactionsWithAccountsSuccess) {
        groupedData = getGroupedReasonData(
          transactions: state.transactions,
          reasons: state.reasons,
          period: selectedPeriod,
        );
      } else {
        groupedData = {};
      }
    });
  }

  void _changePeriod(bool forward) {
    final idx = periodOptions.indexOf(selectedPeriod);
    final next =
        forward
            ? (idx + 1) % periodOptions.length
            : (idx - 1 + periodOptions.length) % periodOptions.length;
    _onPeriodTap(periodOptions[next]);
  }

  Map<String, double> getGroupedReasonData({
    required List<AllTransactionsModel> transactions,
    required List<IncomeExpenseReasons> reasons,
    required String period,
  }) {
    final now = DateTime.now();

    bool isInPeriod(DateTime txDate) {
      switch (period) {
        case 'День':
          return txDate.day == now.day &&
              txDate.month == now.month &&
              txDate.year == now.year;
        case 'Неделя':
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          return txDate.isAfter(
                startOfWeek.subtract(const Duration(days: 1)),
              ) &&
              txDate.isBefore(endOfWeek.add(const Duration(days: 1)));
        case 'Месяц':
          return txDate.month == now.month && txDate.year == now.year;
        case 'Год':
          return txDate.year == now.year;
        default:
          return true;
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

      final reasonId = tx.incomeExpenseReason!;
      final reasonName = reasonNames[reasonId] ?? 'Другое';
      final amount = double.tryParse(tx.amount ?? '0') ?? 0;

      grouped[reasonName] = (grouped[reasonName] ?? 0) + amount;
    }

    return grouped;
  }
}

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
  PieChartDynamicPainter({required this.data});

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

    final colors = [
      const Color(0xFF4600D7),
      const Color(0xFFBC6FF8),
      const Color(0xFF8385F2),
      const Color(0xFFFCA12C),
      const Color(0xFF1EBF93),
    ];

    final segments = data.entries.toList();

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
