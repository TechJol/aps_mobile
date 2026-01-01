// ignore_for_file: deprecated_member_use

import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.primaryColorLight, AppColors.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SoftkgPro Premium',
                  style: AppTextStyles.f18w700.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                8.h,

                Text(
                  'Полный доступ к сервису\nдля вашего бизнеса',
                  style: AppTextStyles.f12w400.copyWith(
                    color: AppColors.whiteColor.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          10.h,

          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/icons/logotypenew.jpg',
              width: 77,
              height: 77,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
