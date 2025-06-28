import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class LocalService {
  Future<void> exportToExcelGeneric({
    required String fileName,
    required List<String> headers,
    required List<List<String>> rows,
    required BuildContext context,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Отчет'];

    // Заголовки
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

    // Данные
    for (final row in rows) {
      sheet.appendRow(row.map((cell) => TextCellValue(cell)).toList());
    }

    final fileBytes = excel.save();
    if (fileBytes == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.xlsx');
    await file.writeAsBytes(fileBytes, flush: true);

    // Разрешение для Android
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нет разрешения на запись файла')),
        );
        return;
      }
    }

    // Сообщение
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Файл "$fileName.xlsx" успешно сохранен!')),
    );

    // Поделиться
    await Share.shareXFiles([XFile(file.path)]);
  }

  Future<void> printReportAsPdf({
    required BuildContext context,
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    final pdf = pw.Document();

    // 👇 Загрузим шрифт с поддержкой кириллицы
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: headers,
              data: rows,
              border: pw.TableBorder.all(),
              cellStyle: pw.TextStyle(font: ttf, fontSize: 10),
              headerStyle: pw.TextStyle(
                font: ttf,
                fontWeight: pw.FontWeight.bold,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
            ),
          ];
        },
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Формирование PDF...')));

    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      debugPrint('Ошибка при печати: $e');
    }
  }
}
