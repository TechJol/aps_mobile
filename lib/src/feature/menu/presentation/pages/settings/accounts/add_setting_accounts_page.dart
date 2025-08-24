import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSettingAccountsPage extends StatefulWidget {
  const AddSettingAccountsPage({super.key});

  @override
  State<AddSettingAccountsPage> createState() => _AddSettingAccountsPageState();
}

class _AddSettingAccountsPageState extends State<AddSettingAccountsPage> {
  final nameController = TextEditingController();

  final List<String> currencies = [
    t.account.dollar,
    t.account.som,
    t.account.ruble,
    t.account.euro,
  ];
  final List<String> currenciesCodes = ['USD', 'KGS', 'RUB', 'EUR'];

  final List<String> types = [t.account.bank, t.account.cash];
  final List<String> typesCodes = ['bank', 'cash'];

  // final List<String> names = ['Бакай банк', 'Офис касса'];

  // String? selectedName;
  String? selectedType;
  String? selectedCurrency;
  String? selectedCurrencyCode;
  String? selectedTypeCode;

  bool isFormValid = false;

  void checkFormValidity() {
    setState(() {
      isFormValid =
          // selectedName != null &&
          selectedType != null &&
          selectedCurrency != null &&
          // selectedName!.isNotEmpty &&
          selectedType!.isNotEmpty &&
          selectedCurrency!.isNotEmpty;
      isFormValid = nameController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkFormValidity);
  }

  @override
  void dispose() {
    nameController.removeListener(checkFormValidity);
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.account.addAccount,
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is MenuAccountsSuccess) {
            Navigator.pop(context);
          }
          if (state is MenuError) {
            var snackBar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.backroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
            24.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFieldWid(
                    label: t.account.name,
                    controller: nameController,
                  ),
                  const SizedBox(height: 12),
                  DropDownFormField(
                    items: types,
                    label: t.account.type,
                    value: selectedType,
                    onChanged: (val) {
                      setState(() {
                        selectedType = val;
                        final index = types.indexOf(val ?? '');
                        selectedTypeCode =
                            index != -1 ? typesCodes[index] : null;
                      });
                      checkFormValidity();
                    },
                  ),
                  const SizedBox(height: 12),
                  DropDownFormField(
                    items: currencies,
                    label: t.account.currency,
                    value: selectedCurrency,
                    onChanged: (val) {
                      setState(() {
                        selectedCurrency = val;
                        final index = currencies.indexOf(val ?? '');
                        selectedCurrencyCode =
                            index != -1 ? currenciesCodes[index] : null;
                      });
                      checkFormValidity();
                    },
                  ),

                  const SizedBox(height: 24),

                  BlocBuilder<MenuCubit, MenuState>(
                    builder: (context, state) {
                      if (state is MenuLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed:
                            isFormValid
                                ? () {
                                  final account = AccountModel(
                                    name: nameController.text.trim(),
                                    accountType: selectedTypeCode ?? '',
                                    currency: selectedCurrencyCode,
                                  );
                                  context.read<MenuCubit>().postAccount(
                                    account,
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary200Color,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          t.account.save,
                          style: AppTextStyles.f16w500.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
