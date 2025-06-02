import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class OperationPage extends StatelessWidget {
  const OperationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F4F7),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Text('Привет , Aяна', style: AppTextStyles.f24w600),
        ),
        centerTitle: false,
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
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.menu);
                },
                icon: const Icon(Icons.more_vert_outlined),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextFormField(
                onTap: () {},
                readOnly: true,
                // controller: controller,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  labelStyle: AppTextStyles.f16w500,
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                  fillColor: AppColors.backroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: AppColors.backroundColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      width: 1,
                      color: AppColors.backroundColor,
                    ),
                  ),
                  hintText: 'Выбрать период',
                  // labelText: label,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
