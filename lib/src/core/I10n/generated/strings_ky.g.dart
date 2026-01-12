///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsKy extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsKy({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ky,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ky>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsKy _root = this; // ignore: unused_field

	@override 
	TranslationsKy $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsKy(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAccountKy account = _TranslationsAccountKy._(_root);
	@override late final _TranslationsAuthKy auth = _TranslationsAuthKy._(_root);
	@override late final _TranslationsHomeKy home = _TranslationsHomeKy._(_root);
	@override late final _TranslationsIncomeKy income = _TranslationsIncomeKy._(_root);
	@override late final _TranslationsMenuKy menu = _TranslationsMenuKy._(_root);
	@override late final _TranslationsOperationKy operation = _TranslationsOperationKy._(_root);
	@override late final _TranslationsPaymentKy payment = _TranslationsPaymentKy._(_root);
}

// Path: account
class _TranslationsAccountKy extends TranslationsAccountEn {
	_TranslationsAccountKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAccountAccountKy account = _TranslationsAccountAccountKy._(_root);
	@override String get accountManagement => 'Эсептерди башкаруу';
	@override String get totalBalances => 'Жалпы баланстар';
	@override String get addAccount => 'Эсеп кошуу';
	@override String get moreDetails => 'кененирээк';
	@override String get edit => 'Оңдоо';
	@override String get delete => 'Өчүрүү';
	@override String get name => 'Аты';
	@override String get typeAccount => 'Эсеп түрү';
	@override String get type => 'Түрү';
	@override String get currency => 'Валюта';
	@override String get save => 'Сактоо';
	@override String get cancel => 'Жокко чыгаруу';
	@override String get yes => 'Ооба';
	@override String get confirmDelete => 'Бул эсепти чын эле өчүрөсүзбү';
	@override String get moreInfo => 'Кошумча маалымат';
	@override String get print => 'Басып чыгаруу';
	@override String get export => 'Excelге экспорттоо';
	@override String get balanceAllSummary => 'Баланс жана жалпы суммалар';
	@override String get allTransactionsWithAccount => 'Эсеп боюнча бардык транзакциялар';
	@override String get totalSumIncome => 'Жалпы киреше';
	@override String get totalSumExpense => 'Жалпы чыгым';
	@override String get currentBalance => 'Учурдагы баланс';
	@override String get date => 'Дата';
	@override String get typeTransaction => 'Транзакция түрү';
	@override String get reason => 'Себеп';
	@override String get income => 'Киреше';
	@override String get expense => 'Чыгым';
	@override String get errors => 'Ката';
	@override String get bank => 'Банк';
	@override String get cash => 'Касса';
	@override String get unknownType => 'Белгисиз';
	@override String get dollar => 'Доллар';
	@override String get som => 'Сом';
	@override String get ruble => 'Рубль';
	@override String get euro => 'Евро';
	@override String get settingsAccounts => 'Эсептер орнотуулары';
}

// Path: auth
class _TranslationsAuthKy extends TranslationsAuthEn {
	_TranslationsAuthKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get welcome => 'Салам!\nКош келдиңиз';
	@override String get login => 'Кирүү';
	@override String get register => 'Катталуу';
	@override String get logIn => 'Логин';
	@override String get password => 'Сырсөз';
	@override String get company => 'Компания';
	@override String get username => 'Колдонуучу аты';
	@override String get email => 'E-mail';
	@override String get name => 'Аты';
	@override String get surname => 'Фамилиясы';
	@override String get thingPassword => 'Сырсөз түзүү';
	@override String get agreement => 'Мен колдонуучу келишиминин бардык шарттарына макулмун';
	@override String get registerButton => 'Катталуу';
	@override String get loginButton => 'Кирүү';
	@override String get forgotPassword => 'Сырсөздү унуттуңузбу?';
	@override late final _TranslationsAuthValidationKy validation = _TranslationsAuthValidationKy._(_root);
	@override late final _TranslationsAuthErrorsKy errors = _TranslationsAuthErrorsKy._(_root);
}

// Path: home
class _TranslationsHomeKy extends TranslationsHomeEn {
	_TranslationsHomeKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get appbar => 'SoftkgPro';
	@override String get home => 'Башкы бет';
	@override String get day => 'Күн';
	@override String get week => 'Апта';
	@override String get month => 'Ай';
	@override String get year => 'Жыл';
	@override String get expenses => 'Чыгымдар';
	@override String get income => 'Кирешелер';
	@override String get all => 'Жалпы';
	@override String get operations => 'Операциялар';
	@override String get seeAll => 'баарын көрүү';
	@override String get noData => 'Бул мезгилде маалымат жок';
	@override String get loading => 'Жүктөлүүдө...';
	@override String get noOperations => 'Операциялар жок';
	@override String get unknown => 'Белгисиз';
	@override String get other => 'Башка';
}

// Path: income
class _TranslationsIncomeKy extends TranslationsIncomeEn {
	_TranslationsIncomeKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get incomes => 'Кирешелер';
	@override String get expenses => 'Чыгымдар';
	@override String get account => 'Эсеп';
	@override String get notAccount => 'Эсептер жок..';
	@override String get sum => 'Сумма';
	@override String get article => 'Берене';
	@override String get notArticle => 'Беренелер жок..';
	@override String get partnerType => 'Контрагент тиби';
	@override String get notPartnerType => 'Контрагент түрлөрү жок';
	@override String get partner => 'Контрагент';
	@override String get notPartner => 'Контрагенттер жок';
	@override String get addPartner => 'Контрагент кошуу';
	@override String get description => 'Сүрөттөмө';
	@override String get pleaseFillInAllFields => 'Бардык талааларды толтуруңуз';
	@override String get save => 'Сактоо';
	@override String get time => 'Убакыт';
	@override String get select => 'Тандоо';
}

// Path: menu
class _TranslationsMenuKy extends TranslationsMenuEn {
	_TranslationsMenuKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get menuTitle => 'Меню';
	@override String get operations => 'Бардык операциялар';
	@override String get operationsAll => 'Бардык транзакциялар';
	@override String get operationsByCounterparties => 'Контрагенттер боюнча';
	@override String get operationsByAccounts => 'Эсептер боюнча';
	@override String get reports => 'Отчеттор';
	@override String get reportsByArticles => 'Беренелер боюнча отчеттор';
	@override String get reportsIncomeExpenseSummary => 'Жалпы абал';
	@override String get reportsMonthly => 'Айлык киреше жана чыгым';
	@override String get reportsMetrics => 'Көрсөткүчтөр';
	@override String get settings => 'Орнотуулар';
	@override String get settingsCounterparties => 'Контрагенттер';
	@override String get settingsCounterpartyTypes => 'Контрагент түрлөрү';
	@override String get settingsAccounts => 'Эсептер';
	@override String get settingsArticles => 'Беренелер';
	@override String get logout => 'Чыгуу';
	@override late final _TranslationsMenuProfileKy profile = _TranslationsMenuProfileKy._(_root);
	@override String get error => 'Ката';
	@override late final _TranslationsMenuTypeCounterpartiesKy typeCounterparties = _TranslationsMenuTypeCounterpartiesKy._(_root);
	@override String get save => 'Сактоо';
	@override String get delete => 'Өчүрүү';
	@override String get edit => 'Түзөтүү';
	@override late final _TranslationsMenuCounterpartiesKy counterparties = _TranslationsMenuCounterpartiesKy._(_root);
	@override late final _TranslationsMenuArticlesKy articles = _TranslationsMenuArticlesKy._(_root);
	@override String get income => 'Киреше';
	@override String get expense => 'Чыгым';
	@override late final _TranslationsMenuCommonKy common = _TranslationsMenuCommonKy._(_root);
	@override late final _TranslationsMenuMonthsKy months = _TranslationsMenuMonthsKy._(_root);
	@override late final _TranslationsMenuReportsByArticleKy reportsByArticle = _TranslationsMenuReportsByArticleKy._(_root);
	@override late final _TranslationsMenuArticleKy article = _TranslationsMenuArticleKy._(_root);
	@override late final _TranslationsMenuIncomeExpenseSummaryKy incomeExpenseSummary = _TranslationsMenuIncomeExpenseSummaryKy._(_root);
	@override String get noData => 'Маалымат жок';
	@override late final _TranslationsMenuMonthlyReportKy monthlyReport = _TranslationsMenuMonthlyReportKy._(_root);
	@override late final _TranslationsMenuMetricsKy metrics = _TranslationsMenuMetricsKy._(_root);
	@override late final _TranslationsMenuTransactionsKy transactions = _TranslationsMenuTransactionsKy._(_root);
	@override late final _TranslationsMenuForCounterpartiesKy forCounterparties = _TranslationsMenuForCounterpartiesKy._(_root);
	@override late final _TranslationsMenuAccountsKy accounts = _TranslationsMenuAccountsKy._(_root);
	@override late final _TranslationsMenuLanguageKy language = _TranslationsMenuLanguageKy._(_root);
	@override String get interface => 'Интерфейс';
	@override late final _TranslationsMenuThemeKy theme = _TranslationsMenuThemeKy._(_root);
}

// Path: operation
class _TranslationsOperationKy extends TranslationsOperationEn {
	_TranslationsOperationKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get operation => 'Операциялар';
	@override String get selectPeriod => 'Периодду тандаңыз';
	@override String get filter => 'Фильтр';
	@override String get resetFilter => 'Фильтрди тазалоо';
	@override String get partnerSuccessUpdate => 'Партнер ийгиликтүү жаңыртылды!';
	@override String get error => 'Ката';
	@override String get notOperation => 'Операциялар жок';
	@override String get hasPartner => 'Бул операцияга партнер буга чейин дайындалган';
	@override String get week => 'Жума';
	@override String get oneMonth => '1 ай';
	@override String get threeMonth => '3 ай';
	@override String get plusPartner => '+ Контрагент';
	@override String get start => 'Башталышы';
	@override String get end => 'Аягы';
	@override String get show => 'Көрсөтүү';
	@override String get addPartner => 'Контрагент кошуу';
	@override String get selectTypeAndPartner => 'Түрүн жана контрагентти тандаңыз';
	@override String get selectType => 'Түрүн тандаңыз';
	@override String get selectPartner => 'Контрагентти тандаңыз';
	@override String get cancel => 'Жокко чыгаруу';
	@override String get yes => 'Ооба';
	@override String get notFoundPartner => 'Партнер табылган жок';
}

// Path: payment
class _TranslationsPaymentKy extends TranslationsPaymentEn {
	_TranslationsPaymentKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get headerTitle => 'SoftkgPro Premium';
	@override String get headerSubtitle => 'Бизнесиңиз үчүн\nкызматка толук мүмкүнчүлүк';
	@override String get subscribeTitle => 'Жазылууну тариздеңиз';
	@override String get subscribeDescription => 'SoftkgPro\'нун бардык мүмкүнчүлүктөрүн ачыңыз жана каржыны чектөөсүз башкарыңыз.';
	@override late final _TranslationsPaymentFeaturesKy features = _TranslationsPaymentFeaturesKy._(_root);
	@override String get choosePlanTitle => 'Тариф тандаңыз';
	@override String get plansUnavailable => 'Тарифтер убактылуу жеткиликсиз';
	@override String get subscribeButton => 'Жазылууну тариздөө';
	@override String get autoRenew => 'Жазылуу автоматтык түрдө узартылат. Каалаган убакта жөндөөлөрдөн токтотсоңуз болот.';
	@override String get perPeriod => 'мөөнөт үчүн';
	@override String get discountSubtitle => 'Үнөмдөө {percent}%';
	@override String get trialSubtitle => 'Сынама тариф';
	@override String get recommendedBadge => 'Сунуштайбыз';
	@override String get paymentProcessedSnack => 'Төлөм иштетилди. Жазылуу кийинчерээк активдешет, кайра аракет кылыңыз.';
	@override String get refreshStatus => 'Статусту жаңыртуу';
	@override String get accountMissing => 'Эсеп табылган жок. Эсептер тизмесин текшериңиз.';
	@override String get activeStatus => 'Активдүү: {planName} — {daysLeft} күн калды';
	@override String get processingTitle => 'Төлөм ийгиликтүү иштетилди';
	@override String get processingSubtitle => '{secondsLeft} секундадан кийин башкы бетке кайтарабыз';
	@override String get successTitle => 'Төлөмүңүз ийгиликтүү аяктады!';
	@override String get successBody => 'Куттуктайбыз! Эми сиз {planName} планынын катышуучусусуз';
	@override String get subscriptionPeriodLabel => 'Жазылуу мөөнөтү';
	@override String get endDateLabel => 'Аяктоо датасы';
	@override String get totalAmountLabel => 'Төлөм суммасы';
	@override String get mainButton => 'Башкы';
	@override String get retryButton => 'Кайра аракет';
	@override String get planFallback => 'План';
	@override String get currencyKgs => 'сом';
	@override String get monthsShort => 'ай';
	@override String months({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ky'))(n,
		one: 'ай',
		few: 'ай',
		many: 'ай',
		other: 'ай',
	);
}

// Path: account.account
class _TranslationsAccountAccountKy extends TranslationsAccountAccountEn {
	_TranslationsAccountAccountKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAccountAccountAccountKy account = _TranslationsAccountAccountAccountKy._(_root);
	@override late final _TranslationsAccountAccountActionsKy actions = _TranslationsAccountAccountActionsKy._(_root);
	@override late final _TranslationsAccountAccountMessagesKy messages = _TranslationsAccountAccountMessagesKy._(_root);
	@override late final _TranslationsAccountAccountErrorsKy errors = _TranslationsAccountAccountErrorsKy._(_root);
}

// Path: auth.validation
class _TranslationsAuthValidationKy extends TranslationsAuthValidationEn {
	_TranslationsAuthValidationKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get companyInvalid => 'Компаниянын аталышы туура эмес';
	@override String get usernameInvalid => 'Тамга, сан жана _ гана (3–20)';
	@override String get emailInvalid => 'E-mail туура эмес';
	@override String get nameInvalid => 'Тамга, дефис жана боштук гана (2–50)';
	@override String get surnameInvalid => 'Тамга, дефис жана боштук гана (2–50)';
	@override String get passwordInvalid => 'Кеминде 8 символ, бир тамга жана бир сан болсун';
}

// Path: auth.errors
class _TranslationsAuthErrorsKy extends TranslationsAuthErrorsEn {
	_TranslationsAuthErrorsKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get companyExists => 'Мындай аталыштагы компания мурунтан бар';
	@override String get emailExists => 'Бул E-mail менен колдонуучу мурунтан бар';
	@override String get usernameExists => 'Бул логин менен колдонуучу мурунтан бар';
	@override String get unknown => 'Катталууда ката кетти';
}

// Path: menu.profile
class _TranslationsMenuProfileKy extends TranslationsMenuProfileEn {
	_TranslationsMenuProfileKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get profile => 'Профиль';
	@override String get next => 'Андан ары';
	@override String get deleteAccount => 'Аккаунтту өчүрүү';
	@override String get account => 'Аккаунт';
}

// Path: menu.typeCounterparties
class _TranslationsMenuTypeCounterpartiesKy extends TranslationsMenuTypeCounterpartiesEn {
	_TranslationsMenuTypeCounterpartiesKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Контрагент түрлөрү';
	@override String get addType => 'Түр кошуу';
	@override String get editType => 'Түрдү түзөтүү';
	@override String get print => 'Басып чыгаруу';
	@override String get export => 'Excelге экспорттоо';
	@override String get name => 'Аталышы';
	@override String get delete => 'Түрдү өчүрүү';
	@override String get notFound => 'Контрагент түрлөрү жок';
}

// Path: menu.counterparties
class _TranslationsMenuCounterpartiesKy extends TranslationsMenuCounterpartiesEn {
	_TranslationsMenuCounterpartiesKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Контрагенттер';
	@override String get addCounterparty => 'Контрагент кошуу';
	@override String get editCounterparty => 'Контрагентти түзөтүү';
	@override String get deleteCounterparty => 'Контрагентти өчүрүү';
	@override String get print => 'Басып чыгаруу';
	@override String get export => 'Excelге экспорттоо';
	@override String get name => 'Аталышы';
	@override String get type => 'Түрү';
	@override String get notFound => 'Контрагенттер жок';
	@override String get phoneNumber => 'Байланыш маалыматы';
}

// Path: menu.articles
class _TranslationsMenuArticlesKy extends TranslationsMenuArticlesEn {
	_TranslationsMenuArticlesKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Беренелер';
	@override String get addArticle => 'Берене кошуу';
	@override String get editArticle => 'Берене түзөтүү';
	@override String get deleteArticle => 'Беренени өчүрүү';
	@override String get print => 'Басып чыгаруу';
	@override String get export => 'Excelге экспорттоо';
	@override String get name => 'Аталышы';
	@override String get type => 'Түрү';
	@override String get income => 'Киреше';
	@override String get expense => 'Чыгым';
	@override String get notFound => 'Беренелер жок';
}

// Path: menu.common
class _TranslationsMenuCommonKy extends TranslationsMenuCommonEn {
	_TranslationsMenuCommonKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get print => 'Басып чыгаруу';
	@override String get export => 'Excelге экспорттоо';
	@override String get amountKgs => 'Сумма (сом)';
	@override String get percent => 'Пайыз';
	@override String get numberSign => '№';
	@override String get noDataForSelectedMonth => 'Тандалган ай боюнча маалымат жок';
	@override String get untitled => 'Аталышы жок';
	@override String get unknown => 'Белгисиз';
}

// Path: menu.months
class _TranslationsMenuMonthsKy extends TranslationsMenuMonthsEn {
	_TranslationsMenuMonthsKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get january => 'Январь';
	@override String get february => 'Февраль';
	@override String get march => 'Март';
	@override String get april => 'Апрель';
	@override String get may => 'Май';
	@override String get june => 'Июнь';
	@override String get july => 'Июль';
	@override String get august => 'Август';
	@override String get september => 'Сентябрь';
	@override String get october => 'Октябрь';
	@override String get november => 'Ноябрь';
	@override String get december => 'Декабрь';
}

// Path: menu.reportsByArticle
class _TranslationsMenuReportsByArticleKy extends TranslationsMenuReportsByArticleEn {
	_TranslationsMenuReportsByArticleKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Беренелер боюнча отчеттор';
	@override String get filenamePrefix => 'Беренелер_отчету_ай_';
	@override late final _TranslationsMenuReportsByArticleMarkersKy markers = _TranslationsMenuReportsByArticleMarkersKy._(_root);
	@override late final _TranslationsMenuReportsByArticleSectionsKy sections = _TranslationsMenuReportsByArticleSectionsKy._(_root);
}

// Path: menu.article
class _TranslationsMenuArticleKy extends TranslationsMenuArticleEn {
	_TranslationsMenuArticleKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get name => 'Аталышы';
	@override String get income => 'Киреше';
	@override String get expense => 'Чыгым';
}

// Path: menu.incomeExpenseSummary
class _TranslationsMenuIncomeExpenseSummaryKy extends TranslationsMenuIncomeExpenseSummaryEn {
	_TranslationsMenuIncomeExpenseSummaryKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Жалпы абал';
	@override String get currency => 'Валюта';
	@override String get income => 'Киреше';
	@override String get expense => 'Чыгым';
	@override String get balance => 'Баланс';
	@override String get balanceKgz => 'Баланс (KGS)';
	@override String get exchangeRate => 'Валюта курсу';
}

// Path: menu.monthlyReport
class _TranslationsMenuMonthlyReportKy extends TranslationsMenuMonthlyReportEn {
	_TranslationsMenuMonthlyReportKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Айлык отчет';
	@override String get incomeTitle => 'Киреше';
	@override String get filenamePrefix => 'Айлык_отчет_';
	@override late final _TranslationsMenuMonthlyReportTableKy table = _TranslationsMenuMonthlyReportTableKy._(_root);
	@override String get noData => 'Тандалган ай боюнча маалымат жок';
}

// Path: menu.metrics
class _TranslationsMenuMetricsKy extends TranslationsMenuMetricsEn {
	_TranslationsMenuMetricsKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Көрсөткүчтөр';
	@override String get yearlyReportTitle => 'Жылдык отчет';
	@override String get yearlyReportFilename => 'Жылдык_отчет';
	@override String get year => 'Жыл';
	@override String get incomeKgz => 'Киреше (KGZ)';
	@override String get expenseKgz => 'Чыгым (KGZ)';
	@override String get netIncomeKgz => 'Таза киреше (KGZ)';
	@override String get byYears => 'жылдар боюнча';
	@override String get selectPeriod => 'Периодду тандаңыз';
	@override String get tableTitle => 'Жылдар боюнча киреше/чыгым таблицасы';
	@override String get chartTitle => 'Жылдар боюнча киреше/чыгым графиги';
}

// Path: menu.transactions
class _TranslationsMenuTransactionsKy extends TranslationsMenuTransactionsEn {
	_TranslationsMenuTransactionsKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Бардык транзакциялар';
	@override String get notFound => 'Транзакциялар жок';
	@override String get printTitle => 'Бардык транзакциялар боюнча отчет';
	@override String get fileName => 'Бардык_транзакциялар';
	@override late final _TranslationsMenuTransactionsTableKy table = _TranslationsMenuTransactionsTableKy._(_root);
}

// Path: menu.forCounterparties
class _TranslationsMenuForCounterpartiesKy extends TranslationsMenuForCounterpartiesEn {
	_TranslationsMenuForCounterpartiesKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Контрагент категориялары';
	@override String get noTypes => 'Категориялар жок';
	@override String get noPartnersInType => 'Бул категорияда контрагенттер жок';
	@override String get name => 'Аты';
	@override String get balance => 'Баланс';
	@override String get contacts => 'Контакттар';
}

// Path: menu.accounts
class _TranslationsMenuAccountsKy extends TranslationsMenuAccountsEn {
	_TranslationsMenuAccountsKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get total => 'жалпы баланс';
	@override String get printTitle => 'Эсептер отчету';
	@override String get fileName => 'Эсептер_бойунча';
	@override late final _TranslationsMenuAccountsHeadersKy headers = _TranslationsMenuAccountsHeadersKy._(_root);
	@override late final _TranslationsMenuAccountsTypeKy type = _TranslationsMenuAccountsTypeKy._(_root);
}

// Path: menu.language
class _TranslationsMenuLanguageKy extends TranslationsMenuLanguageEn {
	_TranslationsMenuLanguageKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Тил';
	@override String get system => 'Системалык';
	@override String get english => 'Англисче';
	@override String get russian => 'Орусча';
	@override String get kyrgyz => 'Кыргызча';
	@override String get select => 'Тилди тандаңыз';
}

// Path: menu.theme
class _TranslationsMenuThemeKy extends TranslationsMenuThemeEn {
	_TranslationsMenuThemeKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Тема';
	@override String get light => 'Жарык';
	@override String get dark => 'Караңгы';
	@override String get system => 'Системалык';
}

// Path: payment.features
class _TranslationsPaymentFeaturesKy extends TranslationsPaymentFeaturesEn {
	_TranslationsPaymentFeaturesKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get unlimitedOps => 'Чексиз операциялар жана отчеттор';
	@override String get historyAnalytics => 'Тарых, аналитика жана экспорт';
	@override String get support => 'Колдоо 24/7 колдонмодо';
}

// Path: account.account.account
class _TranslationsAccountAccountAccountKy extends TranslationsAccountAccountAccountEn {
	_TranslationsAccountAccountAccountKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get title => 'Эсеп';
	@override String get description => 'Эсептерди башкаруу';
}

// Path: account.account.actions
class _TranslationsAccountAccountActionsKy extends TranslationsAccountAccountActionsEn {
	_TranslationsAccountAccountActionsKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get addAccount => 'Эсеп кошуу';
	@override String get editAccount => 'Эсепти оңдоо';
	@override String get deleteAccount => 'Эсепти өчүрүү';
}

// Path: account.account.messages
class _TranslationsAccountAccountMessagesKy extends TranslationsAccountAccountMessagesEn {
	_TranslationsAccountAccountMessagesKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get accountAdded => 'Эсеп ийгиликтүү кошулду';
	@override String get accountUpdated => 'Эсеп ийгиликтүү жаңыртылды';
	@override String get accountDeleted => 'Эсеп ийгиликтүү өчүрүлдү';
}

// Path: account.account.errors
class _TranslationsAccountAccountErrorsKy extends TranslationsAccountAccountErrorsEn {
	_TranslationsAccountAccountErrorsKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get accountNotFound => 'Эсеп табылган жок';
	@override String get notAccounts => 'Эсептер жок';
	@override String get accountAlreadyExists => 'Мындай аталыштагы эсеп бар';
}

// Path: menu.reportsByArticle.markers
class _TranslationsMenuReportsByArticleMarkersKy extends TranslationsMenuReportsByArticleMarkersEn {
	_TranslationsMenuReportsByArticleMarkersKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get income => '--- КИРЕШЕ ---';
	@override String get expense => '--- ЧЫГЫМ ---';
}

// Path: menu.reportsByArticle.sections
class _TranslationsMenuReportsByArticleSectionsKy extends TranslationsMenuReportsByArticleSectionsEn {
	_TranslationsMenuReportsByArticleSectionsKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get incomeTitle => 'Негизги киреше беренелери';
	@override String get expenseTitle => 'Негизги чыгым беренелери';
	@override String get incomeNameCol => 'Киреше беренеси';
	@override String get expenseNameCol => 'Чыгым беренеси';
}

// Path: menu.monthlyReport.table
class _TranslationsMenuMonthlyReportTableKy extends TranslationsMenuMonthlyReportTableEn {
	_TranslationsMenuMonthlyReportTableKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get month => 'Ай';
	@override String get income => 'Киреше (KGS)';
	@override String get expense => 'Чыгым (KGS)';
	@override String get balance => 'Таза киреше (KGS)';
}

// Path: menu.transactions.table
class _TranslationsMenuTransactionsTableKy extends TranslationsMenuTransactionsTableEn {
	_TranslationsMenuTransactionsTableKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get amount => 'Сумма';
	@override String get currency => 'Валюта';
	@override String get currencyShort => 'Вл';
	@override String get date => 'Дата';
	@override String get type => 'Түрү';
	@override String get account => 'Эсеп';
	@override String get article => 'Берене';
	@override String get counterparty => 'Контрагент';
	@override String get comment => 'Комментарий';
	@override String get deleted => 'Өчүрүлгөн';
	@override String get edited => 'Өзгөртүлгөн';
}

// Path: menu.accounts.headers
class _TranslationsMenuAccountsHeadersKy extends TranslationsMenuAccountsHeadersEn {
	_TranslationsMenuAccountsHeadersKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get name => 'Аталышы';
	@override String get balance => 'Баланс';
	@override String get accountType => 'Эсеп түрү';
}

// Path: menu.accounts.type
class _TranslationsMenuAccountsTypeKy extends TranslationsMenuAccountsTypeEn {
	_TranslationsMenuAccountsTypeKy._(TranslationsKy root) : this._root = root, super.internal(root);

	final TranslationsKy _root; // ignore: unused_field

	// Translations
	@override String get cash => 'Касса';
	@override String get bank => 'Банк';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsKy {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'account.account.account.title': return 'Эсеп';
			case 'account.account.account.description': return 'Эсептерди башкаруу';
			case 'account.account.actions.addAccount': return 'Эсеп кошуу';
			case 'account.account.actions.editAccount': return 'Эсепти оңдоо';
			case 'account.account.actions.deleteAccount': return 'Эсепти өчүрүү';
			case 'account.account.messages.accountAdded': return 'Эсеп ийгиликтүү кошулду';
			case 'account.account.messages.accountUpdated': return 'Эсеп ийгиликтүү жаңыртылды';
			case 'account.account.messages.accountDeleted': return 'Эсеп ийгиликтүү өчүрүлдү';
			case 'account.account.errors.accountNotFound': return 'Эсеп табылган жок';
			case 'account.account.errors.notAccounts': return 'Эсептер жок';
			case 'account.account.errors.accountAlreadyExists': return 'Мындай аталыштагы эсеп бар';
			case 'account.accountManagement': return 'Эсептерди башкаруу';
			case 'account.totalBalances': return 'Жалпы баланстар';
			case 'account.addAccount': return 'Эсеп кошуу';
			case 'account.moreDetails': return 'кененирээк';
			case 'account.edit': return 'Оңдоо';
			case 'account.delete': return 'Өчүрүү';
			case 'account.name': return 'Аты';
			case 'account.typeAccount': return 'Эсеп түрү';
			case 'account.type': return 'Түрү';
			case 'account.currency': return 'Валюта';
			case 'account.save': return 'Сактоо';
			case 'account.cancel': return 'Жокко чыгаруу';
			case 'account.yes': return 'Ооба';
			case 'account.confirmDelete': return 'Бул эсепти чын эле өчүрөсүзбү';
			case 'account.moreInfo': return 'Кошумча маалымат';
			case 'account.print': return 'Басып чыгаруу';
			case 'account.export': return 'Excelге экспорттоо';
			case 'account.balanceAllSummary': return 'Баланс жана жалпы суммалар';
			case 'account.allTransactionsWithAccount': return 'Эсеп боюнча бардык транзакциялар';
			case 'account.totalSumIncome': return 'Жалпы киреше';
			case 'account.totalSumExpense': return 'Жалпы чыгым';
			case 'account.currentBalance': return 'Учурдагы баланс';
			case 'account.date': return 'Дата';
			case 'account.typeTransaction': return 'Транзакция түрү';
			case 'account.reason': return 'Себеп';
			case 'account.income': return 'Киреше';
			case 'account.expense': return 'Чыгым';
			case 'account.errors': return 'Ката';
			case 'account.bank': return 'Банк';
			case 'account.cash': return 'Касса';
			case 'account.unknownType': return 'Белгисиз';
			case 'account.dollar': return 'Доллар';
			case 'account.som': return 'Сом';
			case 'account.ruble': return 'Рубль';
			case 'account.euro': return 'Евро';
			case 'account.settingsAccounts': return 'Эсептер орнотуулары';
			case 'auth.welcome': return 'Салам!\nКош келдиңиз';
			case 'auth.login': return 'Кирүү';
			case 'auth.register': return 'Катталуу';
			case 'auth.logIn': return 'Логин';
			case 'auth.password': return 'Сырсөз';
			case 'auth.company': return 'Компания';
			case 'auth.username': return 'Колдонуучу аты';
			case 'auth.email': return 'E-mail';
			case 'auth.name': return 'Аты';
			case 'auth.surname': return 'Фамилиясы';
			case 'auth.thingPassword': return 'Сырсөз түзүү';
			case 'auth.agreement': return 'Мен колдонуучу келишиминин бардык шарттарына макулмун';
			case 'auth.registerButton': return 'Катталуу';
			case 'auth.loginButton': return 'Кирүү';
			case 'auth.forgotPassword': return 'Сырсөздү унуттуңузбу?';
			case 'auth.validation.companyInvalid': return 'Компаниянын аталышы туура эмес';
			case 'auth.validation.usernameInvalid': return 'Тамга, сан жана _ гана (3–20)';
			case 'auth.validation.emailInvalid': return 'E-mail туура эмес';
			case 'auth.validation.nameInvalid': return 'Тамга, дефис жана боштук гана (2–50)';
			case 'auth.validation.surnameInvalid': return 'Тамга, дефис жана боштук гана (2–50)';
			case 'auth.validation.passwordInvalid': return 'Кеминде 8 символ, бир тамга жана бир сан болсун';
			case 'auth.errors.companyExists': return 'Мындай аталыштагы компания мурунтан бар';
			case 'auth.errors.emailExists': return 'Бул E-mail менен колдонуучу мурунтан бар';
			case 'auth.errors.usernameExists': return 'Бул логин менен колдонуучу мурунтан бар';
			case 'auth.errors.unknown': return 'Катталууда ката кетти';
			case 'home.appbar': return 'SoftkgPro';
			case 'home.home': return 'Башкы бет';
			case 'home.day': return 'Күн';
			case 'home.week': return 'Апта';
			case 'home.month': return 'Ай';
			case 'home.year': return 'Жыл';
			case 'home.expenses': return 'Чыгымдар';
			case 'home.income': return 'Кирешелер';
			case 'home.all': return 'Жалпы';
			case 'home.operations': return 'Операциялар';
			case 'home.seeAll': return 'баарын көрүү';
			case 'home.noData': return 'Бул мезгилде маалымат жок';
			case 'home.loading': return 'Жүктөлүүдө...';
			case 'home.noOperations': return 'Операциялар жок';
			case 'home.unknown': return 'Белгисиз';
			case 'home.other': return 'Башка';
			case 'income.incomes': return 'Кирешелер';
			case 'income.expenses': return 'Чыгымдар';
			case 'income.account': return 'Эсеп';
			case 'income.notAccount': return 'Эсептер жок..';
			case 'income.sum': return 'Сумма';
			case 'income.article': return 'Берене';
			case 'income.notArticle': return 'Беренелер жок..';
			case 'income.partnerType': return 'Контрагент тиби';
			case 'income.notPartnerType': return 'Контрагент түрлөрү жок';
			case 'income.partner': return 'Контрагент';
			case 'income.notPartner': return 'Контрагенттер жок';
			case 'income.addPartner': return 'Контрагент кошуу';
			case 'income.description': return 'Сүрөттөмө';
			case 'income.pleaseFillInAllFields': return 'Бардык талааларды толтуруңуз';
			case 'income.save': return 'Сактоо';
			case 'income.time': return 'Убакыт';
			case 'income.select': return 'Тандоо';
			case 'menu.menuTitle': return 'Меню';
			case 'menu.operations': return 'Бардык операциялар';
			case 'menu.operationsAll': return 'Бардык транзакциялар';
			case 'menu.operationsByCounterparties': return 'Контрагенттер боюнча';
			case 'menu.operationsByAccounts': return 'Эсептер боюнча';
			case 'menu.reports': return 'Отчеттор';
			case 'menu.reportsByArticles': return 'Беренелер боюнча отчеттор';
			case 'menu.reportsIncomeExpenseSummary': return 'Жалпы абал';
			case 'menu.reportsMonthly': return 'Айлык киреше жана чыгым';
			case 'menu.reportsMetrics': return 'Көрсөткүчтөр';
			case 'menu.settings': return 'Орнотуулар';
			case 'menu.settingsCounterparties': return 'Контрагенттер';
			case 'menu.settingsCounterpartyTypes': return 'Контрагент түрлөрү';
			case 'menu.settingsAccounts': return 'Эсептер';
			case 'menu.settingsArticles': return 'Беренелер';
			case 'menu.logout': return 'Чыгуу';
			case 'menu.profile.profile': return 'Профиль';
			case 'menu.profile.next': return 'Андан ары';
			case 'menu.profile.deleteAccount': return 'Аккаунтту өчүрүү';
			case 'menu.profile.account': return 'Аккаунт';
			case 'menu.error': return 'Ката';
			case 'menu.typeCounterparties.title': return 'Контрагент түрлөрү';
			case 'menu.typeCounterparties.addType': return 'Түр кошуу';
			case 'menu.typeCounterparties.editType': return 'Түрдү түзөтүү';
			case 'menu.typeCounterparties.print': return 'Басып чыгаруу';
			case 'menu.typeCounterparties.export': return 'Excelге экспорттоо';
			case 'menu.typeCounterparties.name': return 'Аталышы';
			case 'menu.typeCounterparties.delete': return 'Түрдү өчүрүү';
			case 'menu.typeCounterparties.notFound': return 'Контрагент түрлөрү жок';
			case 'menu.save': return 'Сактоо';
			case 'menu.delete': return 'Өчүрүү';
			case 'menu.edit': return 'Түзөтүү';
			case 'menu.counterparties.title': return 'Контрагенттер';
			case 'menu.counterparties.addCounterparty': return 'Контрагент кошуу';
			case 'menu.counterparties.editCounterparty': return 'Контрагентти түзөтүү';
			case 'menu.counterparties.deleteCounterparty': return 'Контрагентти өчүрүү';
			case 'menu.counterparties.print': return 'Басып чыгаруу';
			case 'menu.counterparties.export': return 'Excelге экспорттоо';
			case 'menu.counterparties.name': return 'Аталышы';
			case 'menu.counterparties.type': return 'Түрү';
			case 'menu.counterparties.notFound': return 'Контрагенттер жок';
			case 'menu.counterparties.phoneNumber': return 'Байланыш маалыматы';
			case 'menu.articles.title': return 'Беренелер';
			case 'menu.articles.addArticle': return 'Берене кошуу';
			case 'menu.articles.editArticle': return 'Берене түзөтүү';
			case 'menu.articles.deleteArticle': return 'Беренени өчүрүү';
			case 'menu.articles.print': return 'Басып чыгаруу';
			case 'menu.articles.export': return 'Excelге экспорттоо';
			case 'menu.articles.name': return 'Аталышы';
			case 'menu.articles.type': return 'Түрү';
			case 'menu.articles.income': return 'Киреше';
			case 'menu.articles.expense': return 'Чыгым';
			case 'menu.articles.notFound': return 'Беренелер жок';
			case 'menu.income': return 'Киреше';
			case 'menu.expense': return 'Чыгым';
			case 'menu.common.print': return 'Басып чыгаруу';
			case 'menu.common.export': return 'Excelге экспорттоо';
			case 'menu.common.amountKgs': return 'Сумма (сом)';
			case 'menu.common.percent': return 'Пайыз';
			case 'menu.common.numberSign': return '№';
			case 'menu.common.noDataForSelectedMonth': return 'Тандалган ай боюнча маалымат жок';
			case 'menu.common.untitled': return 'Аталышы жок';
			case 'menu.common.unknown': return 'Белгисиз';
			case 'menu.months.january': return 'Январь';
			case 'menu.months.february': return 'Февраль';
			case 'menu.months.march': return 'Март';
			case 'menu.months.april': return 'Апрель';
			case 'menu.months.may': return 'Май';
			case 'menu.months.june': return 'Июнь';
			case 'menu.months.july': return 'Июль';
			case 'menu.months.august': return 'Август';
			case 'menu.months.september': return 'Сентябрь';
			case 'menu.months.october': return 'Октябрь';
			case 'menu.months.november': return 'Ноябрь';
			case 'menu.months.december': return 'Декабрь';
			case 'menu.reportsByArticle.title': return 'Беренелер боюнча отчеттор';
			case 'menu.reportsByArticle.filenamePrefix': return 'Беренелер_отчету_ай_';
			case 'menu.reportsByArticle.markers.income': return '--- КИРЕШЕ ---';
			case 'menu.reportsByArticle.markers.expense': return '--- ЧЫГЫМ ---';
			case 'menu.reportsByArticle.sections.incomeTitle': return 'Негизги киреше беренелери';
			case 'menu.reportsByArticle.sections.expenseTitle': return 'Негизги чыгым беренелери';
			case 'menu.reportsByArticle.sections.incomeNameCol': return 'Киреше беренеси';
			case 'menu.reportsByArticle.sections.expenseNameCol': return 'Чыгым беренеси';
			case 'menu.article.name': return 'Аталышы';
			case 'menu.article.income': return 'Киреше';
			case 'menu.article.expense': return 'Чыгым';
			case 'menu.incomeExpenseSummary.title': return 'Жалпы абал';
			case 'menu.incomeExpenseSummary.currency': return 'Валюта';
			case 'menu.incomeExpenseSummary.income': return 'Киреше';
			case 'menu.incomeExpenseSummary.expense': return 'Чыгым';
			case 'menu.incomeExpenseSummary.balance': return 'Баланс';
			case 'menu.incomeExpenseSummary.balanceKgz': return 'Баланс (KGS)';
			case 'menu.incomeExpenseSummary.exchangeRate': return 'Валюта курсу';
			case 'menu.noData': return 'Маалымат жок';
			case 'menu.monthlyReport.title': return 'Айлык отчет';
			case 'menu.monthlyReport.incomeTitle': return 'Киреше';
			case 'menu.monthlyReport.filenamePrefix': return 'Айлык_отчет_';
			case 'menu.monthlyReport.table.month': return 'Ай';
			case 'menu.monthlyReport.table.income': return 'Киреше (KGS)';
			case 'menu.monthlyReport.table.expense': return 'Чыгым (KGS)';
			case 'menu.monthlyReport.table.balance': return 'Таза киреше (KGS)';
			case 'menu.monthlyReport.noData': return 'Тандалган ай боюнча маалымат жок';
			case 'menu.metrics.title': return 'Көрсөткүчтөр';
			case 'menu.metrics.yearlyReportTitle': return 'Жылдык отчет';
			case 'menu.metrics.yearlyReportFilename': return 'Жылдык_отчет';
			case 'menu.metrics.year': return 'Жыл';
			case 'menu.metrics.incomeKgz': return 'Киреше (KGZ)';
			case 'menu.metrics.expenseKgz': return 'Чыгым (KGZ)';
			case 'menu.metrics.netIncomeKgz': return 'Таза киреше (KGZ)';
			case 'menu.metrics.byYears': return 'жылдар боюнча';
			case 'menu.metrics.selectPeriod': return 'Периодду тандаңыз';
			case 'menu.metrics.tableTitle': return 'Жылдар боюнча киреше/чыгым таблицасы';
			case 'menu.metrics.chartTitle': return 'Жылдар боюнча киреше/чыгым графиги';
			case 'menu.transactions.title': return 'Бардык транзакциялар';
			case 'menu.transactions.notFound': return 'Транзакциялар жок';
			case 'menu.transactions.printTitle': return 'Бардык транзакциялар боюнча отчет';
			case 'menu.transactions.fileName': return 'Бардык_транзакциялар';
			case 'menu.transactions.table.amount': return 'Сумма';
			case 'menu.transactions.table.currency': return 'Валюта';
			case 'menu.transactions.table.currencyShort': return 'Вл';
			case 'menu.transactions.table.date': return 'Дата';
			case 'menu.transactions.table.type': return 'Түрү';
			case 'menu.transactions.table.account': return 'Эсеп';
			case 'menu.transactions.table.article': return 'Берене';
			case 'menu.transactions.table.counterparty': return 'Контрагент';
			case 'menu.transactions.table.comment': return 'Комментарий';
			case 'menu.transactions.table.deleted': return 'Өчүрүлгөн';
			case 'menu.transactions.table.edited': return 'Өзгөртүлгөн';
			case 'menu.forCounterparties.title': return 'Контрагент категориялары';
			case 'menu.forCounterparties.noTypes': return 'Категориялар жок';
			case 'menu.forCounterparties.noPartnersInType': return 'Бул категорияда контрагенттер жок';
			case 'menu.forCounterparties.name': return 'Аты';
			case 'menu.forCounterparties.balance': return 'Баланс';
			case 'menu.forCounterparties.contacts': return 'Контакттар';
			case 'menu.accounts.total': return 'жалпы баланс';
			case 'menu.accounts.printTitle': return 'Эсептер отчету';
			case 'menu.accounts.fileName': return 'Эсептер_бойунча';
			case 'menu.accounts.headers.name': return 'Аталышы';
			case 'menu.accounts.headers.balance': return 'Баланс';
			case 'menu.accounts.headers.accountType': return 'Эсеп түрү';
			case 'menu.accounts.type.cash': return 'Касса';
			case 'menu.accounts.type.bank': return 'Банк';
			case 'menu.language.title': return 'Тил';
			case 'menu.language.system': return 'Системалык';
			case 'menu.language.english': return 'Англисче';
			case 'menu.language.russian': return 'Орусча';
			case 'menu.language.kyrgyz': return 'Кыргызча';
			case 'menu.language.select': return 'Тилди тандаңыз';
			case 'menu.interface': return 'Интерфейс';
			case 'menu.theme.title': return 'Тема';
			case 'menu.theme.light': return 'Жарык';
			case 'menu.theme.dark': return 'Караңгы';
			case 'menu.theme.system': return 'Системалык';
			case 'operation.operation': return 'Операциялар';
			case 'operation.selectPeriod': return 'Периодду тандаңыз';
			case 'operation.filter': return 'Фильтр';
			case 'operation.resetFilter': return 'Фильтрди тазалоо';
			case 'operation.partnerSuccessUpdate': return 'Партнер ийгиликтүү жаңыртылды!';
			case 'operation.error': return 'Ката';
			case 'operation.notOperation': return 'Операциялар жок';
			case 'operation.hasPartner': return 'Бул операцияга партнер буга чейин дайындалган';
			case 'operation.week': return 'Жума';
			case 'operation.oneMonth': return '1 ай';
			case 'operation.threeMonth': return '3 ай';
			case 'operation.plusPartner': return '+ Контрагент';
			case 'operation.start': return 'Башталышы';
			case 'operation.end': return 'Аягы';
			case 'operation.show': return 'Көрсөтүү';
			case 'operation.addPartner': return 'Контрагент кошуу';
			case 'operation.selectTypeAndPartner': return 'Түрүн жана контрагентти тандаңыз';
			case 'operation.selectType': return 'Түрүн тандаңыз';
			case 'operation.selectPartner': return 'Контрагентти тандаңыз';
			case 'operation.cancel': return 'Жокко чыгаруу';
			case 'operation.yes': return 'Ооба';
			case 'operation.notFoundPartner': return 'Партнер табылган жок';
			case 'payment.headerTitle': return 'SoftkgPro Premium';
			case 'payment.headerSubtitle': return 'Бизнесиңиз үчүн\nкызматка толук мүмкүнчүлүк';
			case 'payment.subscribeTitle': return 'Жазылууну тариздеңиз';
			case 'payment.subscribeDescription': return 'SoftkgPro\'нун бардык мүмкүнчүлүктөрүн ачыңыз жана каржыны чектөөсүз башкарыңыз.';
			case 'payment.features.unlimitedOps': return 'Чексиз операциялар жана отчеттор';
			case 'payment.features.historyAnalytics': return 'Тарых, аналитика жана экспорт';
			case 'payment.features.support': return 'Колдоо 24/7 колдонмодо';
			case 'payment.choosePlanTitle': return 'Тариф тандаңыз';
			case 'payment.plansUnavailable': return 'Тарифтер убактылуу жеткиликсиз';
			case 'payment.subscribeButton': return 'Жазылууну тариздөө';
			case 'payment.autoRenew': return 'Жазылуу автоматтык түрдө узартылат. Каалаган убакта жөндөөлөрдөн токтотсоңуз болот.';
			case 'payment.perPeriod': return 'мөөнөт үчүн';
			case 'payment.discountSubtitle': return 'Үнөмдөө {percent}%';
			case 'payment.trialSubtitle': return 'Сынама тариф';
			case 'payment.recommendedBadge': return 'Сунуштайбыз';
			case 'payment.paymentProcessedSnack': return 'Төлөм иштетилди. Жазылуу кийинчерээк активдешет, кайра аракет кылыңыз.';
			case 'payment.refreshStatus': return 'Статусту жаңыртуу';
			case 'payment.accountMissing': return 'Эсеп табылган жок. Эсептер тизмесин текшериңиз.';
			case 'payment.activeStatus': return 'Активдүү: {planName} — {daysLeft} күн калды';
			case 'payment.processingTitle': return 'Төлөм ийгиликтүү иштетилди';
			case 'payment.processingSubtitle': return '{secondsLeft} секундадан кийин башкы бетке кайтарабыз';
			case 'payment.successTitle': return 'Төлөмүңүз ийгиликтүү аяктады!';
			case 'payment.successBody': return 'Куттуктайбыз! Эми сиз {planName} планынын катышуучусусуз';
			case 'payment.subscriptionPeriodLabel': return 'Жазылуу мөөнөтү';
			case 'payment.endDateLabel': return 'Аяктоо датасы';
			case 'payment.totalAmountLabel': return 'Төлөм суммасы';
			case 'payment.mainButton': return 'Башкы';
			case 'payment.retryButton': return 'Кайра аракет';
			case 'payment.planFallback': return 'План';
			case 'payment.currencyKgs': return 'сом';
			case 'payment.monthsShort': return 'ай';
			case 'payment.months': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ky'))(n,
				one: 'ай',
				few: 'ай',
				many: 'ай',
				other: 'ай',
			);
			default: return null;
		}
	}
}

