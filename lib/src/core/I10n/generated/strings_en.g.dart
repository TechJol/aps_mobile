///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAccountEn account = TranslationsAccountEn.internal(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn.internal(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn.internal(_root);
	late final TranslationsIncomeEn income = TranslationsIncomeEn.internal(_root);
	late final TranslationsMenuEn menu = TranslationsMenuEn.internal(_root);
	late final TranslationsOperationEn operation = TranslationsOperationEn.internal(_root);
}

// Path: account
class TranslationsAccountEn {
	TranslationsAccountEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAccountAccountEn account = TranslationsAccountAccountEn.internal(_root);

	/// en: 'Account Management'
	String get accountManagement => 'Account Management';

	/// en: 'Total Balances'
	String get totalBalances => 'Total Balances';

	/// en: 'Add Account'
	String get addAccount => 'Add Account';

	/// en: 'more details'
	String get moreDetails => 'more details';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Account type'
	String get typeAccount => 'Account type';

	/// en: 'Type'
	String get type => 'Type';

	/// en: 'Currency'
	String get currency => 'Currency';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Yes'
	String get yes => 'Yes';

	/// en: 'Are you sure you want to delete this account'
	String get confirmDelete => 'Are you sure you want to delete this account';

	/// en: 'More Information'
	String get moreInfo => 'More Information';

	/// en: 'Print'
	String get print => 'Print';

	/// en: 'Export to Excel'
	String get export => 'Export to Excel';

	/// en: 'Balance and Total Amounts'
	String get balanceAllSummary => 'Balance and Total Amounts';

	/// en: 'All Transactions with Account'
	String get allTransactionsWithAccount => 'All Transactions with Account';

	/// en: 'Total income'
	String get totalSumIncome => 'Total income';

	/// en: 'Total expenses'
	String get totalSumExpense => 'Total expenses';

	/// en: 'Current balance'
	String get currentBalance => 'Current balance';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Transaction type'
	String get typeTransaction => 'Transaction type';

	/// en: 'Reason'
	String get reason => 'Reason';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Expense'
	String get expense => 'Expense';

	/// en: 'Error'
	String get errors => 'Error';

	/// en: 'Bank'
	String get bank => 'Bank';

	/// en: 'Cash'
	String get cash => 'Cash';

	/// en: 'Unknown'
	String get unknownType => 'Unknown';

	/// en: 'Dollar'
	String get dollar => 'Dollar';

	/// en: 'Som'
	String get som => 'Som';

	/// en: 'Ruble'
	String get ruble => 'Ruble';

	/// en: 'Euro'
	String get euro => 'Euro';

	/// en: 'Account Settings'
	String get settingsAccounts => 'Account Settings';
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Hello!\nWelcome'
	String get welcome => 'Hello!\nWelcome';

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Register'
	String get register => 'Register';

	/// en: 'Login'
	String get logIn => 'Login';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Company'
	String get company => 'Company';

	/// en: 'User name'
	String get username => 'User name';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Surname'
	String get surname => 'Surname';

	/// en: 'Create a password'
	String get thingPassword => 'Create a password';

	/// en: 'I accept all terms of the user agreement'
	String get agreement => 'I accept all terms of the user agreement';

	/// en: 'Register'
	String get registerButton => 'Register';

	/// en: 'Login'
	String get loginButton => 'Login';

	/// en: 'Forgot password?'
	String get forgotPassword => 'Forgot password?';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'SoftkgPro'
	String get appbar => 'SoftkgPro';

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Day'
	String get day => 'Day';

	/// en: 'Week'
	String get week => 'Week';

	/// en: 'Month'
	String get month => 'Month';

	/// en: 'Year'
	String get year => 'Year';

	/// en: 'Expenses'
	String get expenses => 'Expenses';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Total'
	String get all => 'Total';

	/// en: 'Operations'
	String get operations => 'Operations';

	/// en: 'see all'
	String get seeAll => 'see all';

	/// en: 'No data for the period'
	String get noData => 'No data for the period';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'No operations'
	String get noOperations => 'No operations';

	/// en: 'Unknown'
	String get unknown => 'Unknown';

	/// en: 'Other'
	String get other => 'Other';
}

// Path: income
class TranslationsIncomeEn {
	TranslationsIncomeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Incomes'
	String get incomes => 'Incomes';

	/// en: 'Expenses'
	String get expenses => 'Expenses';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'No accounts..'
	String get notAccount => 'No accounts..';

	/// en: 'Sum'
	String get sum => 'Sum';

	/// en: 'Article'
	String get article => 'Article';

	/// en: 'No articles..'
	String get notArticle => 'No articles..';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Please fill in all fields'
	String get pleaseFillInAllFields => 'Please fill in all fields';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Time'
	String get time => 'Time';

	/// en: 'Select'
	String get select => 'Select';
}

// Path: menu
class TranslationsMenuEn {
	TranslationsMenuEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Menu'
	String get menuTitle => 'Menu';

	/// en: 'All operations'
	String get operations => 'All operations';

	/// en: 'All transactions'
	String get operationsAll => 'All transactions';

	/// en: 'By counterparties'
	String get operationsByCounterparties => 'By counterparties';

	/// en: 'By accounts'
	String get operationsByAccounts => 'By accounts';

	/// en: 'Reports'
	String get reports => 'Reports';

	/// en: 'Reports by articles'
	String get reportsByArticles => 'Reports by articles';

	/// en: 'Overall position'
	String get reportsIncomeExpenseSummary => 'Overall position';

	/// en: 'Monthly income & expense report'
	String get reportsMonthly => 'Monthly income & expense report';

	/// en: 'Metrics'
	String get reportsMetrics => 'Metrics';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Counterparties'
	String get settingsCounterparties => 'Counterparties';

	/// en: 'Counterparty types'
	String get settingsCounterpartyTypes => 'Counterparty types';

	/// en: 'Accounts'
	String get settingsAccounts => 'Accounts';

	/// en: 'Articles'
	String get settingsArticles => 'Articles';

	/// en: 'Logout'
	String get logout => 'Logout';

	late final TranslationsMenuProfileEn profile = TranslationsMenuProfileEn.internal(_root);

	/// en: 'Error'
	String get error => 'Error';

	late final TranslationsMenuTypeCounterpartiesEn typeCounterparties = TranslationsMenuTypeCounterpartiesEn.internal(_root);

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Edit'
	String get edit => 'Edit';

	late final TranslationsMenuCounterpartiesEn counterparties = TranslationsMenuCounterpartiesEn.internal(_root);
	late final TranslationsMenuArticlesEn articles = TranslationsMenuArticlesEn.internal(_root);

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Expense'
	String get expense => 'Expense';

	late final TranslationsMenuCommonEn common = TranslationsMenuCommonEn.internal(_root);
	late final TranslationsMenuMonthsEn months = TranslationsMenuMonthsEn.internal(_root);
	late final TranslationsMenuReportsByArticleEn reportsByArticle = TranslationsMenuReportsByArticleEn.internal(_root);
	late final TranslationsMenuArticleEn article = TranslationsMenuArticleEn.internal(_root);
	late final TranslationsMenuIncomeExpenseSummaryEn incomeExpenseSummary = TranslationsMenuIncomeExpenseSummaryEn.internal(_root);

	/// en: 'No data'
	String get noData => 'No data';

	late final TranslationsMenuMonthlyReportEn monthlyReport = TranslationsMenuMonthlyReportEn.internal(_root);
	late final TranslationsMenuMetricsEn metrics = TranslationsMenuMetricsEn.internal(_root);
	late final TranslationsMenuTransactionsEn transactions = TranslationsMenuTransactionsEn.internal(_root);
	late final TranslationsMenuForCounterpartiesEn forCounterparties = TranslationsMenuForCounterpartiesEn.internal(_root);
	late final TranslationsMenuAccountsEn accounts = TranslationsMenuAccountsEn.internal(_root);
	late final TranslationsMenuLanguageEn language = TranslationsMenuLanguageEn.internal(_root);

	/// en: 'Interface'
	String get interface => 'Interface';

	late final TranslationsMenuThemeEn theme = TranslationsMenuThemeEn.internal(_root);
}

// Path: operation
class TranslationsOperationEn {
	TranslationsOperationEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Operations'
	String get operation => 'Operations';

	/// en: 'Select period'
	String get selectPeriod => 'Select period';

	/// en: 'Filter'
	String get filter => 'Filter';

	/// en: 'Reset filter'
	String get resetFilter => 'Reset filter';

	/// en: 'Partner successfully updated!'
	String get partnerSuccessUpdate => 'Partner successfully updated!';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'No operations'
	String get notOperation => 'No operations';

	/// en: 'Partner is already assigned for this operation'
	String get hasPartner => 'Partner is already assigned for this operation';

	/// en: 'Week'
	String get week => 'Week';

	/// en: 'For a month'
	String get oneMonth => 'For a month';

	/// en: 'For 3 months'
	String get threeMonth => 'For 3 months';

	/// en: '+ Counterparty'
	String get plusPartner => '+ Counterparty';

	/// en: 'Start'
	String get start => 'Start';

	/// en: 'End'
	String get end => 'End';

	/// en: 'Show'
	String get show => 'Show';

	/// en: 'Add counterparty'
	String get addPartner => 'Add counterparty';

	/// en: 'Select type and partner'
	String get selectTypeAndPartner => 'Select type and partner';

	/// en: 'Select type'
	String get selectType => 'Select type';

	/// en: 'Select partner'
	String get selectPartner => 'Select partner';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Yes'
	String get yes => 'Yes';

	/// en: 'Partner not found'
	String get notFoundPartner => 'Partner not found';
}

// Path: account.account
class TranslationsAccountAccountEn {
	TranslationsAccountAccountEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAccountAccountAccountEn account = TranslationsAccountAccountAccountEn.internal(_root);
	late final TranslationsAccountAccountActionsEn actions = TranslationsAccountAccountActionsEn.internal(_root);
	late final TranslationsAccountAccountMessagesEn messages = TranslationsAccountAccountMessagesEn.internal(_root);
	late final TranslationsAccountAccountErrorsEn errors = TranslationsAccountAccountErrorsEn.internal(_root);
}

// Path: menu.profile
class TranslationsMenuProfileEn {
	TranslationsMenuProfileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Delete Account'
	String get deleteAccount => 'Delete Account';

	/// en: 'Account'
	String get account => 'Account';
}

// Path: menu.typeCounterparties
class TranslationsMenuTypeCounterpartiesEn {
	TranslationsMenuTypeCounterpartiesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Counterparty types'
	String get title => 'Counterparty types';

	/// en: 'Add type'
	String get addType => 'Add type';

	/// en: 'Edit type'
	String get editType => 'Edit type';

	/// en: 'Print'
	String get print => 'Print';

	/// en: 'Export to Excel'
	String get export => 'Export to Excel';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Delete type'
	String get delete => 'Delete type';

	/// en: 'No counterparty types'
	String get notFound => 'No counterparty types';
}

// Path: menu.counterparties
class TranslationsMenuCounterpartiesEn {
	TranslationsMenuCounterpartiesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Counterparties'
	String get title => 'Counterparties';

	/// en: 'Add counterparty'
	String get addCounterparty => 'Add counterparty';

	/// en: 'Edit counterparty'
	String get editCounterparty => 'Edit counterparty';

	/// en: 'Delete counterparty'
	String get deleteCounterparty => 'Delete counterparty';

	/// en: 'Print'
	String get print => 'Print';

	/// en: 'Export to Excel'
	String get export => 'Export to Excel';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Type'
	String get type => 'Type';

	/// en: 'No counterparties'
	String get notFound => 'No counterparties';

	/// en: 'Contact information'
	String get phoneNumber => 'Contact information';
}

// Path: menu.articles
class TranslationsMenuArticlesEn {
	TranslationsMenuArticlesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Articles'
	String get title => 'Articles';

	/// en: 'Add article'
	String get addArticle => 'Add article';

	/// en: 'Edit article'
	String get editArticle => 'Edit article';

	/// en: 'Delete article'
	String get deleteArticle => 'Delete article';

	/// en: 'Print'
	String get print => 'Print';

	/// en: 'Export to Excel'
	String get export => 'Export to Excel';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Type'
	String get type => 'Type';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Expense'
	String get expense => 'Expense';

	/// en: 'No articles'
	String get notFound => 'No articles';
}

// Path: menu.common
class TranslationsMenuCommonEn {
	TranslationsMenuCommonEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Print'
	String get print => 'Print';

	/// en: 'Export to Excel'
	String get export => 'Export to Excel';

	/// en: 'Amount (KGS)'
	String get amountKgs => 'Amount (KGS)';

	/// en: 'Percent'
	String get percent => 'Percent';

	/// en: '№'
	String get numberSign => '№';

	/// en: 'No data for selected month'
	String get noDataForSelectedMonth => 'No data for selected month';

	/// en: 'Untitled'
	String get untitled => 'Untitled';

	/// en: 'Unknown'
	String get unknown => 'Unknown';
}

// Path: menu.months
class TranslationsMenuMonthsEn {
	TranslationsMenuMonthsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'January'
	String get january => 'January';

	/// en: 'February'
	String get february => 'February';

	/// en: 'March'
	String get march => 'March';

	/// en: 'April'
	String get april => 'April';

	/// en: 'May'
	String get may => 'May';

	/// en: 'June'
	String get june => 'June';

	/// en: 'July'
	String get july => 'July';

	/// en: 'August'
	String get august => 'August';

	/// en: 'September'
	String get september => 'September';

	/// en: 'October'
	String get october => 'October';

	/// en: 'November'
	String get november => 'November';

	/// en: 'December'
	String get december => 'December';
}

// Path: menu.reportsByArticle
class TranslationsMenuReportsByArticleEn {
	TranslationsMenuReportsByArticleEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reports by articles'
	String get title => 'Reports by articles';

	/// en: 'Report_by_articles_month_'
	String get filenamePrefix => 'Report_by_articles_month_';

	late final TranslationsMenuReportsByArticleMarkersEn markers = TranslationsMenuReportsByArticleMarkersEn.internal(_root);
	late final TranslationsMenuReportsByArticleSectionsEn sections = TranslationsMenuReportsByArticleSectionsEn.internal(_root);
}

// Path: menu.article
class TranslationsMenuArticleEn {
	TranslationsMenuArticleEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Expense'
	String get expense => 'Expense';
}

// Path: menu.incomeExpenseSummary
class TranslationsMenuIncomeExpenseSummaryEn {
	TranslationsMenuIncomeExpenseSummaryEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Overall position'
	String get title => 'Overall position';

	/// en: 'Currency'
	String get currency => 'Currency';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Expense'
	String get expense => 'Expense';

	/// en: 'Balance'
	String get balance => 'Balance';

	/// en: 'Balance in KGS'
	String get balanceKgz => 'Balance in KGS';

	/// en: 'Exchange rate'
	String get exchangeRate => 'Exchange rate';
}

// Path: menu.monthlyReport
class TranslationsMenuMonthlyReportEn {
	TranslationsMenuMonthlyReportEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Monthly report'
	String get title => 'Monthly report';

	/// en: 'Income'
	String get incomeTitle => 'Income';

	/// en: 'Monthly_report_'
	String get filenamePrefix => 'Monthly_report_';

	late final TranslationsMenuMonthlyReportTableEn table = TranslationsMenuMonthlyReportTableEn.internal(_root);

	/// en: 'No data for selected month'
	String get noData => 'No data for selected month';
}

// Path: menu.metrics
class TranslationsMenuMetricsEn {
	TranslationsMenuMetricsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Metrics'
	String get title => 'Metrics';

	/// en: 'Yearly report'
	String get yearlyReportTitle => 'Yearly report';

	/// en: 'Yearly_report'
	String get yearlyReportFilename => 'Yearly_report';

	/// en: 'Year'
	String get year => 'Year';

	/// en: 'Income (KGZ)'
	String get incomeKgz => 'Income (KGZ)';

	/// en: 'Expense (KGZ)'
	String get expenseKgz => 'Expense (KGZ)';

	/// en: 'Net income (KGZ)'
	String get netIncomeKgz => 'Net income (KGZ)';

	/// en: 'by years'
	String get byYears => 'by years';

	/// en: 'Select period'
	String get selectPeriod => 'Select period';

	/// en: 'Table of income and expenses by year'
	String get tableTitle => 'Table of income and expenses by year';

	/// en: 'Chart of income and expenses by year'
	String get chartTitle => 'Chart of income and expenses by year';
}

// Path: menu.transactions
class TranslationsMenuTransactionsEn {
	TranslationsMenuTransactionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All transactions'
	String get title => 'All transactions';

	/// en: 'No transactions'
	String get notFound => 'No transactions';

	/// en: 'Report: All transactions'
	String get printTitle => 'Report: All transactions';

	/// en: 'All_transactions'
	String get fileName => 'All_transactions';

	late final TranslationsMenuTransactionsTableEn table = TranslationsMenuTransactionsTableEn.internal(_root);
}

// Path: menu.forCounterparties
class TranslationsMenuForCounterpartiesEn {
	TranslationsMenuForCounterpartiesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Counterparty categories'
	String get title => 'Counterparty categories';

	/// en: 'No categories available'
	String get noTypes => 'No categories available';

	/// en: 'No counterparties in this category'
	String get noPartnersInType => 'No counterparties in this category';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Balance'
	String get balance => 'Balance';

	/// en: 'Contacts'
	String get contacts => 'Contacts';
}

// Path: menu.accounts
class TranslationsMenuAccountsEn {
	TranslationsMenuAccountsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'total balance'
	String get total => 'total balance';

	/// en: 'Accounts report'
	String get printTitle => 'Accounts report';

	/// en: 'By_accounts'
	String get fileName => 'By_accounts';

	late final TranslationsMenuAccountsHeadersEn headers = TranslationsMenuAccountsHeadersEn.internal(_root);
	late final TranslationsMenuAccountsTypeEn type = TranslationsMenuAccountsTypeEn.internal(_root);
}

// Path: menu.language
class TranslationsMenuLanguageEn {
	TranslationsMenuLanguageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get title => 'Language';

	/// en: 'System'
	String get system => 'System';

	/// en: 'English'
	String get english => 'English';

	/// en: 'Russian'
	String get russian => 'Russian';

	/// en: 'Kyrgyz'
	String get kyrgyz => 'Kyrgyz';

	/// en: 'Select language'
	String get select => 'Select language';
}

// Path: menu.theme
class TranslationsMenuThemeEn {
	TranslationsMenuThemeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theme'
	String get title => 'Theme';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Dark'
	String get dark => 'Dark';

	/// en: 'System'
	String get system => 'System';
}

// Path: account.account.account
class TranslationsAccountAccountAccountEn {
	TranslationsAccountAccountAccountEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account'
	String get title => 'Account';

	/// en: 'Manage your accounts'
	String get description => 'Manage your accounts';
}

// Path: account.account.actions
class TranslationsAccountAccountActionsEn {
	TranslationsAccountAccountActionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add Account'
	String get addAccount => 'Add Account';

	/// en: 'Edit Account'
	String get editAccount => 'Edit Account';

	/// en: 'Delete Account'
	String get deleteAccount => 'Delete Account';
}

// Path: account.account.messages
class TranslationsAccountAccountMessagesEn {
	TranslationsAccountAccountMessagesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account successfully added'
	String get accountAdded => 'Account successfully added';

	/// en: 'Account successfully updated'
	String get accountUpdated => 'Account successfully updated';

	/// en: 'Account successfully deleted'
	String get accountDeleted => 'Account successfully deleted';
}

// Path: account.account.errors
class TranslationsAccountAccountErrorsEn {
	TranslationsAccountAccountErrorsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account not found'
	String get accountNotFound => 'Account not found';

	/// en: 'No accounts'
	String get notAccounts => 'No accounts';

	/// en: 'An account with this name already exists'
	String get accountAlreadyExists => 'An account with this name already exists';
}

// Path: menu.reportsByArticle.markers
class TranslationsMenuReportsByArticleMarkersEn {
	TranslationsMenuReportsByArticleMarkersEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '--- INCOME ---'
	String get income => '--- INCOME ---';

	/// en: '--- EXPENSE ---'
	String get expense => '--- EXPENSE ---';
}

// Path: menu.reportsByArticle.sections
class TranslationsMenuReportsByArticleSectionsEn {
	TranslationsMenuReportsByArticleSectionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Top income categories'
	String get incomeTitle => 'Top income categories';

	/// en: 'Top expense categories'
	String get expenseTitle => 'Top expense categories';

	/// en: 'Income category'
	String get incomeNameCol => 'Income category';

	/// en: 'Expense category'
	String get expenseNameCol => 'Expense category';
}

// Path: menu.monthlyReport.table
class TranslationsMenuMonthlyReportTableEn {
	TranslationsMenuMonthlyReportTableEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Month'
	String get month => 'Month';

	/// en: 'Income (KGS)'
	String get income => 'Income (KGS)';

	/// en: 'Expense (KGS)'
	String get expense => 'Expense (KGS)';

	/// en: 'Net income (KGS)'
	String get balance => 'Net income (KGS)';
}

// Path: menu.transactions.table
class TranslationsMenuTransactionsTableEn {
	TranslationsMenuTransactionsTableEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Amount'
	String get amount => 'Amount';

	/// en: 'Currency'
	String get currency => 'Currency';

	/// en: 'Cur'
	String get currencyShort => 'Cur';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Type'
	String get type => 'Type';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Article'
	String get article => 'Article';

	/// en: 'Counterparty'
	String get counterparty => 'Counterparty';

	/// en: 'Comment'
	String get comment => 'Comment';
}

// Path: menu.accounts.headers
class TranslationsMenuAccountsHeadersEn {
	TranslationsMenuAccountsHeadersEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Balance'
	String get balance => 'Balance';

	/// en: 'Account type'
	String get accountType => 'Account type';
}

// Path: menu.accounts.type
class TranslationsMenuAccountsTypeEn {
	TranslationsMenuAccountsTypeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cash'
	String get cash => 'Cash';

	/// en: 'Bank'
	String get bank => 'Bank';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'account.account.account.title': return 'Account';
			case 'account.account.account.description': return 'Manage your accounts';
			case 'account.account.actions.addAccount': return 'Add Account';
			case 'account.account.actions.editAccount': return 'Edit Account';
			case 'account.account.actions.deleteAccount': return 'Delete Account';
			case 'account.account.messages.accountAdded': return 'Account successfully added';
			case 'account.account.messages.accountUpdated': return 'Account successfully updated';
			case 'account.account.messages.accountDeleted': return 'Account successfully deleted';
			case 'account.account.errors.accountNotFound': return 'Account not found';
			case 'account.account.errors.notAccounts': return 'No accounts';
			case 'account.account.errors.accountAlreadyExists': return 'An account with this name already exists';
			case 'account.accountManagement': return 'Account Management';
			case 'account.totalBalances': return 'Total Balances';
			case 'account.addAccount': return 'Add Account';
			case 'account.moreDetails': return 'more details';
			case 'account.edit': return 'Edit';
			case 'account.delete': return 'Delete';
			case 'account.name': return 'Name';
			case 'account.typeAccount': return 'Account type';
			case 'account.type': return 'Type';
			case 'account.currency': return 'Currency';
			case 'account.save': return 'Save';
			case 'account.cancel': return 'Cancel';
			case 'account.yes': return 'Yes';
			case 'account.confirmDelete': return 'Are you sure you want to delete this account';
			case 'account.moreInfo': return 'More Information';
			case 'account.print': return 'Print';
			case 'account.export': return 'Export to Excel';
			case 'account.balanceAllSummary': return 'Balance and Total Amounts';
			case 'account.allTransactionsWithAccount': return 'All Transactions with Account';
			case 'account.totalSumIncome': return 'Total income';
			case 'account.totalSumExpense': return 'Total expenses';
			case 'account.currentBalance': return 'Current balance';
			case 'account.date': return 'Date';
			case 'account.typeTransaction': return 'Transaction type';
			case 'account.reason': return 'Reason';
			case 'account.income': return 'Income';
			case 'account.expense': return 'Expense';
			case 'account.errors': return 'Error';
			case 'account.bank': return 'Bank';
			case 'account.cash': return 'Cash';
			case 'account.unknownType': return 'Unknown';
			case 'account.dollar': return 'Dollar';
			case 'account.som': return 'Som';
			case 'account.ruble': return 'Ruble';
			case 'account.euro': return 'Euro';
			case 'account.settingsAccounts': return 'Account Settings';
			case 'auth.welcome': return 'Hello!\nWelcome';
			case 'auth.login': return 'Login';
			case 'auth.register': return 'Register';
			case 'auth.logIn': return 'Login';
			case 'auth.password': return 'Password';
			case 'auth.company': return 'Company';
			case 'auth.username': return 'User name';
			case 'auth.email': return 'Email';
			case 'auth.name': return 'Name';
			case 'auth.surname': return 'Surname';
			case 'auth.thingPassword': return 'Create a password';
			case 'auth.agreement': return 'I accept all terms of the user agreement';
			case 'auth.registerButton': return 'Register';
			case 'auth.loginButton': return 'Login';
			case 'auth.forgotPassword': return 'Forgot password?';
			case 'home.appbar': return 'SoftkgPro';
			case 'home.home': return 'Home';
			case 'home.day': return 'Day';
			case 'home.week': return 'Week';
			case 'home.month': return 'Month';
			case 'home.year': return 'Year';
			case 'home.expenses': return 'Expenses';
			case 'home.income': return 'Income';
			case 'home.all': return 'Total';
			case 'home.operations': return 'Operations';
			case 'home.seeAll': return 'see all';
			case 'home.noData': return 'No data for the period';
			case 'home.loading': return 'Loading...';
			case 'home.noOperations': return 'No operations';
			case 'home.unknown': return 'Unknown';
			case 'home.other': return 'Other';
			case 'income.incomes': return 'Incomes';
			case 'income.expenses': return 'Expenses';
			case 'income.account': return 'Account';
			case 'income.notAccount': return 'No accounts..';
			case 'income.sum': return 'Sum';
			case 'income.article': return 'Article';
			case 'income.notArticle': return 'No articles..';
			case 'income.description': return 'Description';
			case 'income.pleaseFillInAllFields': return 'Please fill in all fields';
			case 'income.save': return 'Save';
			case 'income.time': return 'Time';
			case 'income.select': return 'Select';
			case 'menu.menuTitle': return 'Menu';
			case 'menu.operations': return 'All operations';
			case 'menu.operationsAll': return 'All transactions';
			case 'menu.operationsByCounterparties': return 'By counterparties';
			case 'menu.operationsByAccounts': return 'By accounts';
			case 'menu.reports': return 'Reports';
			case 'menu.reportsByArticles': return 'Reports by articles';
			case 'menu.reportsIncomeExpenseSummary': return 'Overall position';
			case 'menu.reportsMonthly': return 'Monthly income & expense report';
			case 'menu.reportsMetrics': return 'Metrics';
			case 'menu.settings': return 'Settings';
			case 'menu.settingsCounterparties': return 'Counterparties';
			case 'menu.settingsCounterpartyTypes': return 'Counterparty types';
			case 'menu.settingsAccounts': return 'Accounts';
			case 'menu.settingsArticles': return 'Articles';
			case 'menu.logout': return 'Logout';
			case 'menu.profile.profile': return 'Profile';
			case 'menu.profile.next': return 'Next';
			case 'menu.profile.deleteAccount': return 'Delete Account';
			case 'menu.profile.account': return 'Account';
			case 'menu.error': return 'Error';
			case 'menu.typeCounterparties.title': return 'Counterparty types';
			case 'menu.typeCounterparties.addType': return 'Add type';
			case 'menu.typeCounterparties.editType': return 'Edit type';
			case 'menu.typeCounterparties.print': return 'Print';
			case 'menu.typeCounterparties.export': return 'Export to Excel';
			case 'menu.typeCounterparties.name': return 'Name';
			case 'menu.typeCounterparties.delete': return 'Delete type';
			case 'menu.typeCounterparties.notFound': return 'No counterparty types';
			case 'menu.save': return 'Save';
			case 'menu.delete': return 'Delete';
			case 'menu.edit': return 'Edit';
			case 'menu.counterparties.title': return 'Counterparties';
			case 'menu.counterparties.addCounterparty': return 'Add counterparty';
			case 'menu.counterparties.editCounterparty': return 'Edit counterparty';
			case 'menu.counterparties.deleteCounterparty': return 'Delete counterparty';
			case 'menu.counterparties.print': return 'Print';
			case 'menu.counterparties.export': return 'Export to Excel';
			case 'menu.counterparties.name': return 'Name';
			case 'menu.counterparties.type': return 'Type';
			case 'menu.counterparties.notFound': return 'No counterparties';
			case 'menu.counterparties.phoneNumber': return 'Contact information';
			case 'menu.articles.title': return 'Articles';
			case 'menu.articles.addArticle': return 'Add article';
			case 'menu.articles.editArticle': return 'Edit article';
			case 'menu.articles.deleteArticle': return 'Delete article';
			case 'menu.articles.print': return 'Print';
			case 'menu.articles.export': return 'Export to Excel';
			case 'menu.articles.name': return 'Name';
			case 'menu.articles.type': return 'Type';
			case 'menu.articles.income': return 'Income';
			case 'menu.articles.expense': return 'Expense';
			case 'menu.articles.notFound': return 'No articles';
			case 'menu.income': return 'Income';
			case 'menu.expense': return 'Expense';
			case 'menu.common.print': return 'Print';
			case 'menu.common.export': return 'Export to Excel';
			case 'menu.common.amountKgs': return 'Amount (KGS)';
			case 'menu.common.percent': return 'Percent';
			case 'menu.common.numberSign': return '№';
			case 'menu.common.noDataForSelectedMonth': return 'No data for selected month';
			case 'menu.common.untitled': return 'Untitled';
			case 'menu.common.unknown': return 'Unknown';
			case 'menu.months.january': return 'January';
			case 'menu.months.february': return 'February';
			case 'menu.months.march': return 'March';
			case 'menu.months.april': return 'April';
			case 'menu.months.may': return 'May';
			case 'menu.months.june': return 'June';
			case 'menu.months.july': return 'July';
			case 'menu.months.august': return 'August';
			case 'menu.months.september': return 'September';
			case 'menu.months.october': return 'October';
			case 'menu.months.november': return 'November';
			case 'menu.months.december': return 'December';
			case 'menu.reportsByArticle.title': return 'Reports by articles';
			case 'menu.reportsByArticle.filenamePrefix': return 'Report_by_articles_month_';
			case 'menu.reportsByArticle.markers.income': return '--- INCOME ---';
			case 'menu.reportsByArticle.markers.expense': return '--- EXPENSE ---';
			case 'menu.reportsByArticle.sections.incomeTitle': return 'Top income categories';
			case 'menu.reportsByArticle.sections.expenseTitle': return 'Top expense categories';
			case 'menu.reportsByArticle.sections.incomeNameCol': return 'Income category';
			case 'menu.reportsByArticle.sections.expenseNameCol': return 'Expense category';
			case 'menu.article.name': return 'Name';
			case 'menu.article.income': return 'Income';
			case 'menu.article.expense': return 'Expense';
			case 'menu.incomeExpenseSummary.title': return 'Overall position';
			case 'menu.incomeExpenseSummary.currency': return 'Currency';
			case 'menu.incomeExpenseSummary.income': return 'Income';
			case 'menu.incomeExpenseSummary.expense': return 'Expense';
			case 'menu.incomeExpenseSummary.balance': return 'Balance';
			case 'menu.incomeExpenseSummary.balanceKgz': return 'Balance in KGS';
			case 'menu.incomeExpenseSummary.exchangeRate': return 'Exchange rate';
			case 'menu.noData': return 'No data';
			case 'menu.monthlyReport.title': return 'Monthly report';
			case 'menu.monthlyReport.incomeTitle': return 'Income';
			case 'menu.monthlyReport.filenamePrefix': return 'Monthly_report_';
			case 'menu.monthlyReport.table.month': return 'Month';
			case 'menu.monthlyReport.table.income': return 'Income (KGS)';
			case 'menu.monthlyReport.table.expense': return 'Expense (KGS)';
			case 'menu.monthlyReport.table.balance': return 'Net income (KGS)';
			case 'menu.monthlyReport.noData': return 'No data for selected month';
			case 'menu.metrics.title': return 'Metrics';
			case 'menu.metrics.yearlyReportTitle': return 'Yearly report';
			case 'menu.metrics.yearlyReportFilename': return 'Yearly_report';
			case 'menu.metrics.year': return 'Year';
			case 'menu.metrics.incomeKgz': return 'Income (KGZ)';
			case 'menu.metrics.expenseKgz': return 'Expense (KGZ)';
			case 'menu.metrics.netIncomeKgz': return 'Net income (KGZ)';
			case 'menu.metrics.byYears': return 'by years';
			case 'menu.metrics.selectPeriod': return 'Select period';
			case 'menu.metrics.tableTitle': return 'Table of income and expenses by year';
			case 'menu.metrics.chartTitle': return 'Chart of income and expenses by year';
			case 'menu.transactions.title': return 'All transactions';
			case 'menu.transactions.notFound': return 'No transactions';
			case 'menu.transactions.printTitle': return 'Report: All transactions';
			case 'menu.transactions.fileName': return 'All_transactions';
			case 'menu.transactions.table.amount': return 'Amount';
			case 'menu.transactions.table.currency': return 'Currency';
			case 'menu.transactions.table.currencyShort': return 'Cur';
			case 'menu.transactions.table.date': return 'Date';
			case 'menu.transactions.table.type': return 'Type';
			case 'menu.transactions.table.account': return 'Account';
			case 'menu.transactions.table.article': return 'Article';
			case 'menu.transactions.table.counterparty': return 'Counterparty';
			case 'menu.transactions.table.comment': return 'Comment';
			case 'menu.forCounterparties.title': return 'Counterparty categories';
			case 'menu.forCounterparties.noTypes': return 'No categories available';
			case 'menu.forCounterparties.noPartnersInType': return 'No counterparties in this category';
			case 'menu.forCounterparties.name': return 'Name';
			case 'menu.forCounterparties.balance': return 'Balance';
			case 'menu.forCounterparties.contacts': return 'Contacts';
			case 'menu.accounts.total': return 'total balance';
			case 'menu.accounts.printTitle': return 'Accounts report';
			case 'menu.accounts.fileName': return 'By_accounts';
			case 'menu.accounts.headers.name': return 'Name';
			case 'menu.accounts.headers.balance': return 'Balance';
			case 'menu.accounts.headers.accountType': return 'Account type';
			case 'menu.accounts.type.cash': return 'Cash';
			case 'menu.accounts.type.bank': return 'Bank';
			case 'menu.language.title': return 'Language';
			case 'menu.language.system': return 'System';
			case 'menu.language.english': return 'English';
			case 'menu.language.russian': return 'Russian';
			case 'menu.language.kyrgyz': return 'Kyrgyz';
			case 'menu.language.select': return 'Select language';
			case 'menu.interface': return 'Interface';
			case 'menu.theme.title': return 'Theme';
			case 'menu.theme.light': return 'Light';
			case 'menu.theme.dark': return 'Dark';
			case 'menu.theme.system': return 'System';
			case 'operation.operation': return 'Operations';
			case 'operation.selectPeriod': return 'Select period';
			case 'operation.filter': return 'Filter';
			case 'operation.resetFilter': return 'Reset filter';
			case 'operation.partnerSuccessUpdate': return 'Partner successfully updated!';
			case 'operation.error': return 'Error';
			case 'operation.notOperation': return 'No operations';
			case 'operation.hasPartner': return 'Partner is already assigned for this operation';
			case 'operation.week': return 'Week';
			case 'operation.oneMonth': return 'For a month';
			case 'operation.threeMonth': return 'For 3 months';
			case 'operation.plusPartner': return '+ Counterparty';
			case 'operation.start': return 'Start';
			case 'operation.end': return 'End';
			case 'operation.show': return 'Show';
			case 'operation.addPartner': return 'Add counterparty';
			case 'operation.selectTypeAndPartner': return 'Select type and partner';
			case 'operation.selectType': return 'Select type';
			case 'operation.selectPartner': return 'Select partner';
			case 'operation.cancel': return 'Cancel';
			case 'operation.yes': return 'Yes';
			case 'operation.notFoundPartner': return 'Partner not found';
			default: return null;
		}
	}
}

