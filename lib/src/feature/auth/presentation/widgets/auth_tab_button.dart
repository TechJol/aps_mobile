import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class AuthTabButton extends StatelessWidget {
  const AuthTabButton({
    super.key,
    required this.title,
    required this.active,
    required this.onTap,
    this.width,
  });

  final String title;
  final bool active;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: active
                  ? AppColors.primary200Color
                  : scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: width ?? 100,
            color: active ? AppColors.primary200Color : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
