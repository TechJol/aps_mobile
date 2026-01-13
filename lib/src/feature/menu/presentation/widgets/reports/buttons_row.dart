import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class ButtonsRow extends StatelessWidget {
  final VoidCallback onExport;
  final VoidCallback onPrint;
  const ButtonsRow({super.key, required this.onExport, required this.onPrint});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButtonWidget(text: t.menu.common.print, onPressed: onPrint),
        const SizedBox(width: 12),
        OutlinedButtonWidget(text: t.menu.common.export, onPressed: onExport),
      ],
    );
  }
}
