import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

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
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: cardColor,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.transparent.withOpacity(0.5),
            BlendMode.dstATop,
          ),
          image: AssetImage('assets/images/cardimage.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
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
                    style: AppTextStyles.f16w500.copyWith(color: Colors.white),
                  ),
                  10.w,
                  Icon(Icons.arrow_forward_ios, size: 17, color: Colors.white),
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
