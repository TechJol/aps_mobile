import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.backgroundColor});

  final String title;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: false,
      title: Text(title, style: AppTextStyles.f20w500),
      leadingWidth: 91,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(40),
          ),
          child: IconButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: scheme.onSurface,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
