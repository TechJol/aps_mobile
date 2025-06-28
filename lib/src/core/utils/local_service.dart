import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
}
