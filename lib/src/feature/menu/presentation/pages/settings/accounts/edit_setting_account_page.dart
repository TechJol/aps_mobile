import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditSettingAccountPage extends StatefulWidget {
  const EditSettingAccountPage({super.key, required this.account});

  final AccountModel account;

  @override
  State<EditSettingAccountPage> createState() => _EditSettingAccountPageState();
}

class _EditSettingAccountPageState extends State<EditSettingAccountPage> {
  final List<String> currencies = ['Доллар', 'Сом', 'Рубль', 'Евро'];
  final List<String> currenciesCodes = ['USD', 'KGS', 'RUB', 'EUR'];

  final List<String> types = ['Банк', 'Касса'];
  final List<String> typesCodes = ['bank', 'cash'];

  final nameController = TextEditingController();

  String? selectedCurrency;
  String? selectedType;
  String? selectedCurrencyCode;
  String? selectedTypeCode;

  bool isFormValid = false;

  void checkFormValidity() {
    setState(() {
      isFormValid =
          nameController.text.isNotEmpty &&
          selectedType != null &&
          selectedCurrency != null &&
          selectedType!.isNotEmpty &&
          selectedCurrency!.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    nameController.text = widget.account.name;
    nameController.addListener(checkFormValidity);

    // Устанавливаем отображаемые значения (поиск по кодам)
    final currencyIndex = currenciesCodes.indexOf(
      widget.account.currency ?? '',
    );
    if (currencyIndex != -1) {
      selectedCurrency = currencies[currencyIndex];
      selectedCurrencyCode = currenciesCodes[currencyIndex];
    }

    final typeIndex = typesCodes.indexOf(widget.account.accountType);
    if (typeIndex != -1) {
      selectedType = types[typeIndex];
      selectedTypeCode = typesCodes[typeIndex];
    }

    checkFormValidity(); // вызов после инициализации
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Редактировать счет',
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
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
                  TextFieldWid(label: 'Название', controller: nameController),

                  12.h,
                  DropDownFormField(
                    items: types,
                    label: 'Тип',
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
                  12.h,
                  DropDownFormField(
                    items: currencies,
                    label: 'Валюта',
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

                  24.h,

                  ElevatedButton(
                    onPressed:
                        isFormValid
                            ? () async {
                              final id = widget.account.id;
                              final account = AccountModel(
                                name: nameController.text,
                                currency: selectedCurrencyCode,
                                accountType: selectedTypeCode ?? '',
                              );
                              await context.read<MenuCubit>().updateAccount(
                                account,
                                id!,
                              );
                              Navigator.pop(context, true);
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
                      'Сохранить',
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
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
