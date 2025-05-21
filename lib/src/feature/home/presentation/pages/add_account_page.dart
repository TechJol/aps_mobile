import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class AddAccountPage extends StatelessWidget {
  const AddAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backroundColor,
        centerTitle: false,
        title: Text('Счета', style: AppTextStyles.f24w600),
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.backroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  20.h,
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          label: const Text(
                            'Добавить счет',
                            style: AppTextStyles.f16w500,
                          ),

                          icon: const Icon(Icons.add, size: 20),
                          iconAlignment: IconAlignment.end,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColorLight,
                            foregroundColor: Colors.white,
                            fixedSize: Size(double.infinity, 48),
                          ),
                        ),
                      ),
                    ],
                  ),
                  12.h,
                  Row(
                    children: [
                      OutlinedButtonWidget(
                        onPressed: () {},
                        text: 'Распечатать',
                      ),
                      12.w,
                      OutlinedButtonWidget(
                        onPressed: () {},
                        text: 'Скачать в Excel',
                      ),
                    ],
                  ),
                  20.h,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
