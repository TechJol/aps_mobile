import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class OperationFilterChip extends StatelessWidget {
  const OperationFilterChip({
    super.key,
    required this.label,
    required this.onReset,
  });

  final String label;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '${t.operation.filter}: $label',
              style: AppTextStyles.f14w500,
              softWrap: true,
            ),
          ),
          const SizedBox(width: 12),
          TextButton(onPressed: onReset, child: Text(t.operation.resetFilter)),
        ],
      ),
    );
  }
}
