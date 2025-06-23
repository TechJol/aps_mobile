import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainAccountPage extends StatefulWidget {
  const MainAccountPage({super.key});

  @override
  State<MainAccountPage> createState() => _MainAccountPageState();
}

class _MainAccountPageState extends State<MainAccountPage> {
  @override
  initState() {
    context.read<MenuCubit>().getAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
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
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.menu);
                },
                icon: Icon(Icons.more_vert_outlined),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuError) {
            return Center(child: Text('Ошибка: ${state.message.toString()}'));
          }

          if (state is DeleteError) {
            String message;

            if (state.error is DioException) {
              final err = state.error as DioException;
              final status = err.response?.statusCode;
              final detail = err.response?.data?.toString() ?? err.message;
              message = 'Ошибка удаления [$status]: $detail';
            } else {
              message = 'Ошибка при удалении: ${state.error.toString()}';
            }

            return Center(child: Text(message));
          }

          if (state is MenuAccountsSuccess) {
            final account = state.accounts;
            return _buildAccountSection(context, account);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Padding _buildAccountSection(BuildContext context, List<AccountModel> data) {
    final hasAccount = data.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hasAccount)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'с',
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
                  minimumSize: const Size(140, 48),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.account);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Добавить счет',
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.blackColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.add,
                      size: 20,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          if (hasAccount)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final account = data[index];
                final color =
                    index.isEven ? AppColors.redColor : AppColors.blueColor;

                return CardWidget(
                  onTap: () {},
                  price: ' c',
                  office: account.name,
                  cardColor: color,
                );
              },
            ),
        ],
      ),
    );
  }
}
