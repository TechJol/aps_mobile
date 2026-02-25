import 'package:aps_mobile/src/feature/menu/presentation/pages/settings/counterparties/counterparties_page.dart'
    as settings_counterparties;
import 'package:aps_mobile/src/feature/menu/presentation/pages/settings/counterparties_page.dart'
    as settings_root;
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:finik_sdk/finik_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all presentation pages can be constructed', () {
    final account = AccountModel(
      id: 1,
      name: 'Main',
      accountType: 'cash',
      currency: 'KGS',
      company: 1,
    );
    final reason = IncomeExpenseReasons(
      id: 1,
      name: 'Sale',
      type: 'income',
      company: 1,
    );
    final partner = PartnersModel(
      id: 1,
      name: 'Partner',
      contactInfo: '700000000',
      company: 1,
      type: 1,
    );
    final partnerType = PartnerTypesModel(id: 1, name: 'Client', company: 1);

    final pages = <Object>[
      const HomePage(),
      const ExpenseTransactionsPage(),
      const IncomeTransactionsPage(),
      const OperationPage(),
      const AccountPage(),
      const AddAccountPage(),
      EditAccountPage(account: account),
      const MainAccountPage(),
      MoreInfoPage(account: account),
      const AuthPagerPage(),
      const ForgotPassPage(),
      const NewPassPage(),
      const PassSuccessPage(),
      const LanguageSelection(),
      const MenuPage(),
      const ProfilePage(),
      const SettingsAppPage(),
      const PaymentPage(),
      const PaymentWebViewPage(paymentUrl: 'https://example.com'),
      const FinikPaymentPage(
        apiKey: 'api_key',
        accountId: 'account_id',
        amount: 10,
        itemNameEn: 'Plan',
        description: 'desc',
        callbackUrl: 'https://example.com/callback',
        locale: FinikSdkLocale.RU,
      ),
      const MetricsPage(),
      const CategoryReportsPage(),
      const CounterpartiesReportsPage(),
      const DetailCounterparitesReportsPage(),
      const IncomeExpenseSummaryPage(),
      const TransactionsPage(),
      const ForCounterpartiesPage(),
      const MenuAccountsPage(),
      const AddTypePage(),
      EditTypePage(type: partnerType),
      const TypeCounterpartiesPage(),
      const SettingAccountPage(),
      const AddSettingAccountsPage(),
      EditSettingAccountPage(account: account),
      const ArticlesPage(),
      const AddArticlesPage(),
      EditArticlesPage(reason: reason),
      const AddCounterpartiesPage(),
      settings_counterparties.CounterpartiesPage(),
      EditCounterpartiesPage(partner: partner),
      settings_root.CounterpartiesPage(),
    ];

    expect(pages, isNotEmpty);
    expect(pages.length, 41);
  });
}
