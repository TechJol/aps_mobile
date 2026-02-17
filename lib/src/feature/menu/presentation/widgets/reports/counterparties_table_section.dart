import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class CounterpartiesTableSection extends StatelessWidget {
  const CounterpartiesTableSection({
    super.key,
    required this.title,
    required this.headers,
    required this.rows,
    required this.headerColor,
  });

  final String title;
  final List<String> headers;
  final List<List<String>> rows;
  final Color headerColor;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const nameColW = 180.0;
    const monthColW = 70.0;
    const totalColW = 90.0;
    const cellHPad = 12.0;
    const cellVPad = 10.0;
    final gridColor = isDark ? scheme.outlineVariant : const Color(0xFFE6E6E6);

    final totalColumns = headers.length;
    final minWidth =
        nameColW + (monthColW * 12) + totalColW + (cellHPad * 2 * totalColumns);

    TableRow headerRow() => TableRow(
      decoration: BoxDecoration(color: headerColor),
      children: headers.map((header) {
        return _cell(
          header,
          context: context,
          width: header == headers.first
              ? nameColW
              : header == headers.last
                  ? totalColW
                  : monthColW,
          padH: cellHPad,
          padV: cellVPad,
          isHeader: true,
        );
      }).toList(),
    );

    List<TableRow> dataRows() => rows.map((row) {
      return TableRow(
        children: row.asMap().entries.map((entry) {
          final idx = entry.key;
          final value = entry.value;
          final isFirst = idx == 0;
          final isLast = idx == row.length - 1;
          return _cell(
            value,
            context: context,
            width: isFirst
                ? nameColW
                : isLast
                    ? totalColW
                    : monthColW,
            padH: cellHPad,
            padV: cellVPad,
          );
        }).toList(),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.f16w500),
        12.h,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: Table(
              border: TableBorder.all(color: gridColor, width: 1),
              columnWidths: {
                0: const FixedColumnWidth(nameColW),
                for (var i = 1; i <= 12; i++)
                  i: const FixedColumnWidth(monthColW),
                13: const FixedColumnWidth(totalColW),
              },
              children: [headerRow(), ...dataRows()],
            ),
          ),
        ),
      ],
    );
  }

  Widget _cell(
    String text, {
    required BuildContext context,
    required double width,
    required double padH,
    required double padV,
    bool isHeader = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final style = isHeader
        ? TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w700)
        : AppTextStyles.f14w500.copyWith(color: scheme.onSurface);

    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        child: Text(text, style: style),
      ),
    );
  }
}
