import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/cupertino.dart';
import 'app_routes.dart';
import 'unknown_page.dart';

class RouteGenerator {
  static Route? onGenerate(RouteSettings settings) {
    final route = settings.name;
    // final Object? arguments = settings.arguments;
    // final args = (arguments is Map<String, dynamic>) ? arguments : {};

    switch (route) {
      //! Registration
      case AppRoutes.login:
        return CupertinoPageRoute(builder: (_) => LoginPage());

      case AppRoutes.registration:
        return CupertinoPageRoute(builder: (_) => Registration());

      case AppRoutes.forgotPassword:
        return CupertinoPageRoute(builder: (_) => ForgotPassPage());

      case AppRoutes.languageSelection:
        return CupertinoPageRoute(builder: (_) => LanguageSelection());

      case AppRoutes.newPassword:
        return CupertinoPageRoute(builder: (_) => NewPassPage());

      case AppRoutes.passwordSuccess:
        return CupertinoPageRoute(builder: (_) => PassSuccessPage());

      //! Main
      case AppRoutes.pieChart:
        return CupertinoPageRoute(builder: (_) => HomePage());

      case AppRoutes.main:
        return CupertinoPageRoute(builder: (_) => MainView());

      //! Home
      case AppRoutes.home:
        return CupertinoPageRoute(builder: (_) => MainAccountPage());

      case AppRoutes.account:
        return CupertinoPageRoute(builder: (_) => AccountPage());

      case AppRoutes.addAccount:
        return CupertinoPageRoute(builder: (_) => AddAccountPage());

      case AppRoutes.editAccount:
        return CupertinoPageRoute(builder: (_) => EditAccountPage());

      //! Menu
      case AppRoutes.menu:
        return CupertinoPageRoute(builder: (_) => MenuPage());

      // Operations
      case AppRoutes.transactions:
        return CupertinoPageRoute(builder: (_) => TransactionsPage());

      case AppRoutes.forCounterparties:
        return CupertinoPageRoute(builder: (_) => ForCounterpartiesPage());

      case AppRoutes.menuAccounts:
        return CupertinoPageRoute(builder: (_) => MenuAccountsPage());

      // Reports
      case AppRoutes.categoryReports:
        return CupertinoPageRoute(builder: (_) => CategoryReportsPage());

      case AppRoutes.metrics:
        return CupertinoPageRoute(builder: (_) => MetricsPage());

      case AppRoutes.incomeExpenseSummary:
        return CupertinoPageRoute(builder: (_) => IncomeExpenseSummaryPage());

      case AppRoutes.monthlyReport:
        return CupertinoPageRoute(builder: (_) => MonthlyReportPage());

      // Settings
      case AppRoutes.articles:
        return CupertinoPageRoute(builder: (_) => ArticlesPage());

      case AppRoutes.settingAccount:
        return CupertinoPageRoute(builder: (_) => SettingAccountPage());

      case AppRoutes.typeCounterparties:
        return CupertinoPageRoute(builder: (_) => TypeCounterpartiesPage());

      case AppRoutes.counterparties:
        return CupertinoPageRoute(builder: (_) => CounterpartiesPage());

      // Add and Edit
      case AppRoutes.addCounterparties:
        return CupertinoPageRoute(builder: (_) => AddCounterpartiesPage());

      case AppRoutes.editCounterparties:
        return CupertinoPageRoute(builder: (_) => EditCounterpartiesPage());

      case AppRoutes.addType:
        return CupertinoPageRoute(builder: (_) => AddTypePage());

      case AppRoutes.editType:
        return CupertinoPageRoute(builder: (_) => EditTypePage());

      case AppRoutes.addSettingAccount:
        return CupertinoPageRoute(builder: (_) => AddSettingAccountsPage());

      case AppRoutes.editSettingAccount:
        return CupertinoPageRoute(builder: (_) => EditSettingAccountPage());

      case AppRoutes.addArticles:
        return CupertinoPageRoute(builder: (_) => AddArticlesPage());

      case AppRoutes.editArticles:
        return CupertinoPageRoute(builder: (_) => EditArticlesPage());

      case AppRoutes.profile:
        return CupertinoPageRoute(builder: (_) => ProfilePage());

      default:
        return errorRoute();
    }
  }

  static Route? errorRoute() =>
      CupertinoPageRoute(builder: (_) => const UnknownPage());
}
