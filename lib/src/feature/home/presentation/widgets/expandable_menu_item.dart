import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class ExpandableMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool expanded;
  final VoidCallback onTap;
  final List<String> children;

  const ExpandableMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.expanded,
    required this.onTap,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color:
                  expanded
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryColor),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: AppTextStyles.f16w500)),
                Icon(expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (expanded)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    child: Text(children[i], style: AppTextStyles.f14w400),
                  ),
                  if (i != children.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 24,
                      endIndent: 24,
                      color: Color(0xFFE0E0E0),
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
