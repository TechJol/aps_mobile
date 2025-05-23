import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PopupMenuWid extends StatelessWidget {
  const PopupMenuWid({
    super.key,
    required this.context,
    this.tapDelete,
    this.tapEdit,
  });

  final BuildContext context;
  final void Function()? tapDelete;
  final void Function()? tapEdit;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(Icons.more_vert, size: 15),
          onPressed: () async {
            final RenderBox button = context.findRenderObject() as RenderBox;
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final Offset position = button.localToGlobal(
              Offset.zero,
              ancestor: overlay,
            );

            // Смещение меню (например, вниз на 10 пикселей, вправо на 10)
            final RelativeRect positionRect = RelativeRect.fromLTRB(
              position.dx,
              position.dy + button.size.height,
              position.dx + button.size.width,
              position.dy,
            );

            final selected = await showMenu<String>(
              context: context,
              position: positionRect,

              elevation: 8,
              color: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // нужный радиус
              ),
              items: [
                PopupMenuItem(
                  onTap: tapDelete,
                  value: 'delete',
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/delete.svg'),
                      SizedBox(width: 8),
                      Text('Удалить', style: AppTextStyles.f14w500),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: tapEdit,
                  value: 'edit',
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/edit.svg'),
                      SizedBox(width: 8),
                      Text('Редактировать', style: AppTextStyles.f14w500),
                    ],
                  ),
                ),
              ],
            );

            if (selected == 'edit') {
              // обработка редактирования
            } else if (selected == 'delete') {
              // обработка удаления
            }
          },
        );
      },
    );
  }
}
