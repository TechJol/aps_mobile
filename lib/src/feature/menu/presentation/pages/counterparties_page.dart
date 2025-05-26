import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class CounterpartiesPage extends StatelessWidget {
  const CounterpartiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Категории контрагентов',
        backgroundColor: AppColors.whiteColor,
      ),
    );
  }
}
