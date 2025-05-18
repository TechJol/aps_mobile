import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('Управление счетами', style: AppTextStyles.f24w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.more_vert_outlined),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            30.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('96 000 c', style: AppTextStyles.f24w600),
                    Text(
                      'общий баланс',
                      style: AppTextStyles.f14w500.copyWith(
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'Пополнить',
                        style: AppTextStyles.f16w500.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                      10.w,
                      Icon(Icons.add, size: 20, color: AppColors.blackColor),
                    ],
                  ),
                ),
              ],
            ),
            30.h,
            CardWidget(
              onTap: () {},
              price: '40 512 c',
              office: 'Офис касса',
              cardColor: AppColors.violetColor,
            ),
            20.h,
            CardWidget(
              onTap: () {},
              price: '56 000 c',
              office: 'Бакай банк',
              cardColor: AppColors.blueColor,
            ),
          ],
        ),
      ),
    );
  }
}
