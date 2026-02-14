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
    final scheme = Theme.of(context).colorScheme;
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
              color: expanded
                  ? AppColors.primary50Color.withValues(alpha: 0.2)
                  : Colors.transparent,
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
                    child: SvgPicture.asset(
                      icon,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.f16w500.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
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
                      child: Text(
                        children[i],
                        style: AppTextStyles.f14w400.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  if (i != children.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 24,
                      endIndent: 24,
                      color: scheme.outlineVariant,
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
