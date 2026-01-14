// ignore_for_file: deprecated_member_use

import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final Color baseColor;

  WavePainter(this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [baseColor.withOpacity(0.8), baseColor.withOpacity(0.1)],
      stops: [0.0, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, size.height * 0.15, size.width, size.height * 0.85),
      );

    final path = Path();
    path.moveTo(0, size.height * 0.50);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.35,
      size.width * 0.5,
      size.height * 0.50,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.65,
      size.width,
      size.height * 0.50,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    final strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    this.onTap,
    required this.price,
    required this.office,
    this.currency,
    this.cardColor,
  });

  final void Function()? onTap;
  final String price;
  final String office;
  final String? currency;
  final List<Color>? cardColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: cardColor ?? [Colors.blue, Colors.purple, Colors.pink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: WavePainter(cardColor?.first ?? Colors.blue),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: onTap,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              t.account.moreDetails,
                              style: AppTextStyles.f16w500.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            10.w,
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    price,
                                    style: AppTextStyles.f20w600.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  office,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.f16w500.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          12.w,
                          Container(
                            constraints: const BoxConstraints(minWidth: 56),
                            height: 31,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                currency ?? 'KGZ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.f16w500.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
