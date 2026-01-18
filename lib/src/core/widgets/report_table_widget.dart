import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class ReportTableWidget extends StatelessWidget {
  const ReportTableWidget({
    super.key,
    this.title,
    required this.headers,
    required this.rows,
    required this.columnWidths,
    this.headerColor = AppColors.primaryColorLight,
    this.headerTextColor = Colors.white,
    this.borderColor = const Color(0xFFC9C7C7),
  });

  final String? title;
  final List<String> headers;
  final List<List<String>> rows;
  final List<double> columnWidths;
  final Color headerColor;
  final Color headerTextColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    final totalColumns = headers.length;
    final safeWidths = _normalizeWidths(columnWidths, totalColumns);
    final minWidth =
        safeWidths.fold<double>(0, (sum, w) => sum + w) +
        (totalColumns * 16.0 * 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && title!.isNotEmpty) ...[
          Text(title!, style: AppTextStyles.f16w500),
          12.h,
        ],
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: Table(
              border: TableBorder.all(color: borderColor, width: 1),
              columnWidths: {
                for (var i = 0; i < totalColumns; i++)
                  i: FixedColumnWidth(safeWidths[i]),
              },
              children: [
                _headerRow(headers, safeWidths),
                ...rows.map((row) => _dataRow(row, safeWidths)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableRow _headerRow(List<String> headers, List<double> widths) {
    return TableRow(
      decoration: BoxDecoration(color: headerColor),
      children: [
        for (var i = 0; i < headers.length; i++)
          _cell(headers[i], width: widths[i], isHeader: true),
      ],
    );
  }

  TableRow _dataRow(List<String> row, List<double> widths) {
    final cells = <Widget>[];
    for (var i = 0; i < widths.length; i++) {
      final value = i < row.length ? row[i] : '';
      cells.add(_cell(value, width: widths[i]));
    }
    return TableRow(children: cells);
  }

  Widget _cell(String text, {required double width, bool isHeader = false}) {
    final style = isHeader
        ? TextStyle(color: headerTextColor, fontWeight: FontWeight.w700)
        : AppTextStyles.f14w500;

    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(text, style: style, maxLines: 1),
      ),
    );
  }

  List<double> _normalizeWidths(List<double> widths, int count) {
    if (widths.length == count) return widths;
    if (widths.isEmpty) return List<double>.filled(count, 100);
    return List<double>.generate(count, (i) {
      return i < widths.length ? widths[i] : widths.last;
    });
  }
}
