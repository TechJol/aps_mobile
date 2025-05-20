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

    final paint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromLTWH(
              0,
              size.height * 0.15,
              size.width,
              size.height * 0.85,
            ),
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

    final strokePaint =
        Paint()
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
  final Color? cardColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cardColor!.withOpacity(0.5), // Верх — прозрачнее
              cardColor!.withOpacity(1.0), // Низ — насыщенный
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: WavePainter(cardColor!.withOpacity(0.3)),
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
                              'подробнее',
                              style: AppTextStyles.f16w500.copyWith(
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                price,
                                style: AppTextStyles.f34w600.copyWith(
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                office,
                                style: AppTextStyles.f16w500.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 69,
                            height: 31,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                currency ?? 'KGZ',
                                style: AppTextStyles.f16w500.copyWith(
                                  color: AppColors.whiteColor,
                                  fontFamily: 'Inter',
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
