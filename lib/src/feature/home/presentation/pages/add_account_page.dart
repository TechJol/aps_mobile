import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class AddAccountPage extends StatelessWidget {
  const AddAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backroundColor,
        centerTitle: true,
        title: Text('Добавить счет', style: AppTextStyles.f24w600),
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
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.backroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          30.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                TextFieldWithSuffix(label: 'Название'),
                12.h,
                TextFieldWithSuffix(label: 'Тип'),
                12.h,
                TextFieldWithSuffix(label: 'Валюта'),
                24.h,
                ElevatedButtonWidget(text: 'Сохранить'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
