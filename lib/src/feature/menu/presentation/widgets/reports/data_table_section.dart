import 'package:aps_mobile/src/core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class DataTableSection extends StatelessWidget {
  const DataTableSection({
    super.key,
    required this.data,
    this.nameColumnTitle = 'Статья',
  });
  final List<Map<String, dynamic>> data;
  final String nameColumnTitle;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final textStyle = AppTextStyles.f16w500;

    double measureTextWidth(String text) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(minWidth: 0, maxWidth: double.infinity);
      return tp.width;
    }

    const numColW = 56.0;
    const sumColW = 140.0;
    const pctColW = 110.0;
    const cellHPad = 16.0;
    const cellVPad = 14.0;
    const gridColor = Color(0xFFC9C7C7);

    final maxNameTextW = data.fold<double>(80.0, (maxW, row) {
      final name = (row['name'] ?? '').toString();
      final w = measureTextWidth(name);
      return w > maxW ? w : maxW;
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenW = constraints.maxWidth;

        final fixedPartW = numColW + sumColW + pctColW + (cellHPad * 2 * 4);
        final requiredTableW = fixedPartW + maxNameTextW;
        final tableMinWidth = requiredTableW < screenW
            ? screenW
            : requiredTableW;

        final nameColW = (screenW - fixedPartW).clamp(120.0, 800.0);

        TableRow headerRow() => TableRow(
          decoration: const BoxDecoration(color: AppColors.primaryColorLight),
          children: [
            _cell(
              t.menu.common.numberSign,
              isHeader: true,
              width: numColW,
              padH: cellHPad,
              padV: cellVPad,
            ),
            _cell(
              nameColumnTitle,
              isHeader: true,
              width: tableMinWidth == screenW ? nameColW : maxNameTextW,
              padH: cellHPad,
              padV: cellVPad,
            ),
            _cell(
              t.menu.common.amountKgs,
              isHeader: true,
              width: sumColW,
              padH: cellHPad,
              padV: cellVPad,
            ),
            _cell(
              t.menu.common.percent,
              isHeader: true,
              width: pctColW,
              padH: cellHPad,
              padV: cellVPad,
            ),
          ],
        );

        List<TableRow> dataRows() => data.asMap().entries.map((entry) {
          final i = entry.key + 1;
          final row = entry.value;
          final name = (row['name'] ?? '').toString();
          final amount = (row['amount'] ?? '').toString();
          final percent = row['percent'];

          final isStretched = tableMinWidth == screenW;

          return TableRow(
            children: [
              _cell('$i', width: numColW, padH: cellHPad, padV: cellVPad),
              _cell(
                name,
                width: isStretched ? nameColW : maxNameTextW,
                padH: cellHPad,
                padV: cellVPad,
                ellipsis: isStretched,
              ),
              _cell(amount, width: sumColW, padH: cellHPad, padV: cellVPad),
              _cell(
                percent is Decimal
                    ? '${percent.toString()}%'
                    : '${percent ?? 0}%',
                width: pctColW,
                padH: cellHPad,
                padV: cellVPad,
              ),
            ],
          );
        }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: tableMinWidth),
            child: Table(
              border: TableBorder.all(color: gridColor, width: 1),
              columnWidths: {
                0: const FixedColumnWidth(numColW),
                1: FixedColumnWidth(
                  tableMinWidth == screenW ? nameColW : maxNameTextW,
                ),
                2: const FixedColumnWidth(sumColW),
                3: const FixedColumnWidth(pctColW),
              },
              children: [headerRow(), ...dataRows()],
            ),
          ),
        );
      },
    );
  }

  Widget _cell(
    String text, {
    required double width,
    required double padH,
    required double padV,
    bool isHeader = false,
    bool ellipsis = false,
  }) {
    final style = isHeader
        ? const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)
        : AppTextStyles.f16w500;

    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        child: Text(
          text,
          style: style,
          maxLines: 1,
          overflow: ellipsis ? TextOverflow.ellipsis : TextOverflow.visible,
        ),
      ),
    );
  }
}
