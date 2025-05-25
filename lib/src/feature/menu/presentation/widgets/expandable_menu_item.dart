import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExpandableMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final bool expanded;
  final VoidCallback onTap;
  final List<String> children;
  final void Function(String childTitle)? onChildTap;

  const ExpandableMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.expanded,
    required this.onTap,
    required this.children,
    this.onChildTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            height: 68,
            decoration: BoxDecoration(
              color: expanded ? AppColors.primary50Color : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary200Color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(icon),
                  ),
                ),
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
                  GestureDetector(
                    onTap: () => onChildTap?.call(children[i]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      child: Text(children[i], style: AppTextStyles.f14w400),
                    ),
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
