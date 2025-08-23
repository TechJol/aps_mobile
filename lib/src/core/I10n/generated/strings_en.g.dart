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

	/// en: 'An account with this name already exists'
	String get accountAlreadyExists => 'An account with this name already exists';
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
			default: return null;
		}
	}
}

