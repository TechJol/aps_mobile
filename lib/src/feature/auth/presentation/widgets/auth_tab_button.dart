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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: active ? const Color(0xFF661EFB) : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: width ?? 100,
            color: active ? const Color(0xFF661EFB) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
