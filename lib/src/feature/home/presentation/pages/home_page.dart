import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:aps_mobile/src/core/core.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Управление счетами',
            style: AppTextStyles.f24w600.copyWith(fontFamily: 'Inter'),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '96 000 c',
                      style: AppTextStyles.f24w600.copyWith(
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      'общий баланс',
                      style: AppTextStyles.f14w500.copyWith(
                        color: AppColors.greyColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'Добавить счет',
                        style: AppTextStyles.f16w500.copyWith(
                          color: AppColors.blackColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.add, size: 20, color: AppColors.blackColor),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            CardWidget(
              onTap: () {
                // Действия при нажатии "подробнее"
              },
              price: '40 512 c',
              office: 'Офис касса',
              cardColor: AppColors.primary200Color,
            ),
            SizedBox(height: 20),
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
