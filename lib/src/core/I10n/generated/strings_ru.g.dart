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
class TranslationsRu extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAccountRu account = _TranslationsAccountRu._(_root);
	@override late final _TranslationsAuthRu auth = _TranslationsAuthRu._(_root);
	@override late final _TranslationsHomeRu home = _TranslationsHomeRu._(_root);
	@override late final _TranslationsIncomeRu income = _TranslationsIncomeRu._(_root);
	@override late final _TranslationsMenuRu menu = _TranslationsMenuRu._(_root);
	@override late final _TranslationsOperationRu operation = _TranslationsOperationRu._(_root);
}

// Path: account
class _TranslationsAccountRu extends TranslationsAccountEn {
	_TranslationsAccountRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAccountAccountRu account = _TranslationsAccountAccountRu._(_root);
	@override String get accountManagement => 'Управление счетами';
	@override String get totalBalances => 'общий балансы';
	@override String get addAccount => 'Добавить счет';
	@override String get moreDetails => 'подробнее';
	@override String get edit => 'Редактировать';
	@override String get delete => 'Удалить';
	@override String get name => 'Название';
	@override String get typeAccount => 'Тип счета';
	@override String get type => 'Тип';
	@override String get currency => 'Валюта';
	@override String get save => 'Сохранить';
	@override String get cancel => 'Отмена';
	@override String get yes => 'Да';
	@override String get confirmDelete => 'Вы уверены, что хотите удалить';
	@override String get moreInfo => 'Подробная информация';
	@override String get print => 'Распечатать';
	@override String get export => 'Скачать в Excel';
	@override String get balanceAllSummary => 'Баланс и общие суммы';
	@override String get allTransactionsWithAccount => 'Все транзакции по счету';
	@override String get totalSumIncome => 'Общая сумма доходов';
	@override String get totalSumExpense => 'Общая сумма расходов';
	@override String get currentBalance => 'Текущий баланс';
	@override String get date => 'Дата';
	@override String get typeTransaction => 'Тип транзакции';
	@override String get reason => 'Причина';
	@override String get income => 'Приход';
	@override String get expense => 'Расход';
	@override String get errors => 'Ошибкa';
	@override String get bank => 'Банк';
	@override String get cash => 'Касса';
	@override String get unknownType => 'Неизвестно';
	@override String get dollar => 'Доллар';
	@override String get som => 'Сом';
	@override String get ruble => 'Рубль';
	@override String get euro => 'Евро';
}

// Path: auth
class _TranslationsAuthRu extends TranslationsAuthEn {
	_TranslationsAuthRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get welcome => 'Привет!\nДобро пожаловать';
	@override String get login => 'Войти';
	@override String get register => 'Регистрация';
	@override String get logIn => 'Логин';
	@override String get password => 'Пароль';
	@override String get company => 'Фирма';
	@override String get username => 'Пользовательское имя';
	@override String get email => 'Эл.адрес';
	@override String get name => 'Имя';
	@override String get surname => 'Фамилия';
	@override String get thingPassword => 'Придумайте пароль';
	@override String get agreement => 'Принимаю все условии пользовательского соглашения';
	@override String get registerButton => 'Зарегистрироваться';
	@override String get loginButton => 'Войти';
	@override String get forgotPassword => 'Забыли пароль?';
}

// Path: home
class _TranslationsHomeRu extends TranslationsHomeEn {
	_TranslationsHomeRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get appbar => 'SoftkgPro';
	@override String get home => 'Главная';
	@override String get day => 'День';
	@override String get week => 'Неделя';
	@override String get month => 'Месяц';
	@override String get year => 'Год';
	@override String get expenses => 'Расходы';
	@override String get income => 'Доходы';
	@override String get all => 'Общий';
	@override String get operations => 'Операции';
	@override String get seeAll => 'смотреть все';
	@override String get noData => 'Нет данных за период';
	@override String get loading => 'Загрузка...';
	@override String get noOperations => 'Нет операций';
	@override String get unknown => 'Неизвестно';
}

// Path: income
class _TranslationsIncomeRu extends TranslationsIncomeEn {
	_TranslationsIncomeRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get incomes => 'Доходы';
	@override String get expenses => 'Расходы';
	@override String get account => 'Счет';
	@override String get notAccount => 'Нет счетов..';
	@override String get sum => 'Сумма';
	@override String get article => 'Статья';
	@override String get notArticle => 'Нет статей..';
	@override String get description => 'Описание';
	@override String get pleaseFillInAllFields => 'Пожалуйста, заполните все поля';
	@override String get save => 'Сохранить';
	@override String get time => 'Время';
	@override String get select => 'Выбрать';
}

// Path: menu
class _TranslationsMenuRu extends TranslationsMenuEn {
	_TranslationsMenuRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get menuTitle => 'Меню';
	@override String get operations => 'Все операции';
	@override String get operationsAll => 'Все транзакции';
	@override String get operationsByCounterparties => 'По контрагентам';
	@override String get operationsByAccounts => 'По счетам';
	@override String get reports => 'Отчеты';
	@override String get reportsByArticles => 'Отчеты по статьям';
	@override String get reportsIncomeExpenseSummary => 'Общее положение доходов и расходов';
	@override String get reportsMonthly => 'Месячный отчет по доходам и расходам';
	@override String get reportsMetrics => 'Показатели';
	@override String get settings => 'Настройки';
	@override String get settingsCounterparties => 'Контрагенты';
	@override String get settingsCounterpartyTypes => 'Тип контрагентов';
	@override String get settingsAccounts => 'Счета';
	@override String get settingsArticles => 'Статьи';
	@override String get logout => 'Выход';
	@override late final _TranslationsMenuProfileRu profile = _TranslationsMenuProfileRu._(_root);
	@override String get error => 'Ошибка';
	@override late final _TranslationsMenuTypeCounterpartiesRu typeCounterparties = _TranslationsMenuTypeCounterpartiesRu._(_root);
	@override String get save => 'Сохранить';
	@override String get edit => 'Редактировать';
	@override late final _TranslationsMenuCounterpartiesRu counterparties = _TranslationsMenuCounterpartiesRu._(_root);
}

// Path: operation
class _TranslationsOperationRu extends TranslationsOperationEn {
	_TranslationsOperationRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get operation => 'Операции';
	@override String get selectPeriod => 'Выбрать период';
	@override String get filter => 'Фильтр';
	@override String get resetFilter => 'Сбросить фильтр';
	@override String get partnerSuccessUpdate => 'Партнер успешно обновлен!';
	@override String get error => 'Ошибка';
	@override String get notOperation => 'Нет операций';
	@override String get hasPartner => 'Партнёр уже присвоен для этой операции';
	@override String get week => 'Неделя';
	@override String get oneMonth => 'За месяц';
	@override String get threeMonth => 'За 3 месяца';
	@override String get plusPartner => '+ Контрагент';
	@override String get start => 'Начало';
	@override String get end => 'Конец';
	@override String get show => 'Показать';
	@override String get addPartner => 'Добавить контрагента';
	@override String get selectTypeAndPartner => 'Выберите тип и партнера';
	@override String get selectType => 'Выберите тип';
	@override String get selectPartner => 'Выберите партнера';
	@override String get cancel => 'Отмена';
	@override String get yes => 'Да';
	@override String get notFoundPartner => 'Партнер не найден';
}

// Path: account.account
class _TranslationsAccountAccountRu extends TranslationsAccountAccountEn {
	_TranslationsAccountAccountRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAccountAccountAccountRu account = _TranslationsAccountAccountAccountRu._(_root);
	@override late final _TranslationsAccountAccountActionsRu actions = _TranslationsAccountAccountActionsRu._(_root);
	@override late final _TranslationsAccountAccountMessagesRu messages = _TranslationsAccountAccountMessagesRu._(_root);
	@override late final _TranslationsAccountAccountErrorsRu errors = _TranslationsAccountAccountErrorsRu._(_root);
}

// Path: menu.profile
class _TranslationsMenuProfileRu extends TranslationsMenuProfileEn {
	_TranslationsMenuProfileRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get profile => 'Профиль';
	@override String get next => 'Далее';
	@override String get deleteAccount => 'Удалить Аккаунт';
	@override String get account => 'Аккаунт';
}

// Path: menu.typeCounterparties
class _TranslationsMenuTypeCounterpartiesRu extends TranslationsMenuTypeCounterpartiesEn {
	_TranslationsMenuTypeCounterpartiesRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Типы контрагентов';
	@override String get addType => 'Добавить тип';
	@override String get editType => 'Редактировать тип';
	@override String get print => 'Распечатать';
	@override String get export => 'Скачать в Excel';
	@override String get name => 'Название';
	@override String get delete => 'Удалить тип';
	@override String get notFound => 'Нет типов контрагентов';
}

// Path: menu.counterparties
class _TranslationsMenuCounterpartiesRu extends TranslationsMenuCounterpartiesEn {
	_TranslationsMenuCounterpartiesRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Контрагенты';
	@override String get addCounterparty => 'Добавить контрагента';
	@override String get editCounterparty => 'Редактировать контрагента';
	@override String get deleteCounterparty => 'Удалить контрагента';
	@override String get print => 'Распечатать';
	@override String get export => 'Скачать в Excel';
	@override String get name => 'Название';
	@override String get type => 'Тип';
	@override String get notFound => 'Нет контрагентов';
	@override String get phoneNumber => 'Контактная информация';
}

// Path: account.account.account
class _TranslationsAccountAccountAccountRu extends TranslationsAccountAccountAccountEn {
	_TranslationsAccountAccountAccountRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Счета';
	@override String get description => 'Управление вашими счетами';
}

// Path: account.account.actions
class _TranslationsAccountAccountActionsRu extends TranslationsAccountAccountActionsEn {
	_TranslationsAccountAccountActionsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get addAccount => 'Добавить счет';
	@override String get editAccount => 'Редактировать счет';
	@override String get deleteAccount => 'Удалить счет';
}

// Path: account.account.messages
class _TranslationsAccountAccountMessagesRu extends TranslationsAccountAccountMessagesEn {
	_TranslationsAccountAccountMessagesRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get accountAdded => 'Счет успешно добавлен';
	@override String get accountUpdated => 'Счет успешно обновлен';
	@override String get accountDeleted => 'Счет успешно удален';
}

// Path: account.account.errors
class _TranslationsAccountAccountErrorsRu extends TranslationsAccountAccountErrorsEn {
	_TranslationsAccountAccountErrorsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get accountNotFound => 'Счет не найден';
	@override String get accountAlreadyExists => 'Счет с таким именем уже существует';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'account.account.account.title': return 'Счета';
			case 'account.account.account.description': return 'Управление вашими счетами';
			case 'account.account.actions.addAccount': return 'Добавить счет';
			case 'account.account.actions.editAccount': return 'Редактировать счет';
			case 'account.account.actions.deleteAccount': return 'Удалить счет';
			case 'account.account.messages.accountAdded': return 'Счет успешно добавлен';
			case 'account.account.messages.accountUpdated': return 'Счет успешно обновлен';
			case 'account.account.messages.accountDeleted': return 'Счет успешно удален';
			case 'account.account.errors.accountNotFound': return 'Счет не найден';
			case 'account.account.errors.accountAlreadyExists': return 'Счет с таким именем уже существует';
			case 'account.accountManagement': return 'Управление счетами';
			case 'account.totalBalances': return 'общий балансы';
			case 'account.addAccount': return 'Добавить счет';
			case 'account.moreDetails': return 'подробнее';
			case 'account.edit': return 'Редактировать';
			case 'account.delete': return 'Удалить';
			case 'account.name': return 'Название';
			case 'account.typeAccount': return 'Тип счета';
			case 'account.type': return 'Тип';
			case 'account.currency': return 'Валюта';
			case 'account.save': return 'Сохранить';
			case 'account.cancel': return 'Отмена';
			case 'account.yes': return 'Да';
			case 'account.confirmDelete': return 'Вы уверены, что хотите удалить';
			case 'account.moreInfo': return 'Подробная информация';
			case 'account.print': return 'Распечатать';
			case 'account.export': return 'Скачать в Excel';
			case 'account.balanceAllSummary': return 'Баланс и общие суммы';
			case 'account.allTransactionsWithAccount': return 'Все транзакции по счету';
			case 'account.totalSumIncome': return 'Общая сумма доходов';
			case 'account.totalSumExpense': return 'Общая сумма расходов';
			case 'account.currentBalance': return 'Текущий баланс';
			case 'account.date': return 'Дата';
			case 'account.typeTransaction': return 'Тип транзакции';
			case 'account.reason': return 'Причина';
			case 'account.income': return 'Приход';
			case 'account.expense': return 'Расход';
			case 'account.errors': return 'Ошибкa';
			case 'account.bank': return 'Банк';
			case 'account.cash': return 'Касса';
			case 'account.unknownType': return 'Неизвестно';
			case 'account.dollar': return 'Доллар';
			case 'account.som': return 'Сом';
			case 'account.ruble': return 'Рубль';
			case 'account.euro': return 'Евро';
			case 'auth.welcome': return 'Привет!\nДобро пожаловать';
			case 'auth.login': return 'Войти';
			case 'auth.register': return 'Регистрация';
			case 'auth.logIn': return 'Логин';
			case 'auth.password': return 'Пароль';
			case 'auth.company': return 'Фирма';
			case 'auth.username': return 'Пользовательское имя';
			case 'auth.email': return 'Эл.адрес';
			case 'auth.name': return 'Имя';
			case 'auth.surname': return 'Фамилия';
			case 'auth.thingPassword': return 'Придумайте пароль';
			case 'auth.agreement': return 'Принимаю все условии пользовательского соглашения';
			case 'auth.registerButton': return 'Зарегистрироваться';
			case 'auth.loginButton': return 'Войти';
			case 'auth.forgotPassword': return 'Забыли пароль?';
			case 'home.appbar': return 'SoftkgPro';
			case 'home.home': return 'Главная';
			case 'home.day': return 'День';
			case 'home.week': return 'Неделя';
			case 'home.month': return 'Месяц';
			case 'home.year': return 'Год';
			case 'home.expenses': return 'Расходы';
			case 'home.income': return 'Доходы';
			case 'home.all': return 'Общий';
			case 'home.operations': return 'Операции';
			case 'home.seeAll': return 'смотреть все';
			case 'home.noData': return 'Нет данных за период';
			case 'home.loading': return 'Загрузка...';
			case 'home.noOperations': return 'Нет операций';
			case 'home.unknown': return 'Неизвестно';
			case 'income.incomes': return 'Доходы';
			case 'income.expenses': return 'Расходы';
			case 'income.account': return 'Счет';
			case 'income.notAccount': return 'Нет счетов..';
			case 'income.sum': return 'Сумма';
			case 'income.article': return 'Статья';
			case 'income.notArticle': return 'Нет статей..';
			case 'income.description': return 'Описание';
			case 'income.pleaseFillInAllFields': return 'Пожалуйста, заполните все поля';
			case 'income.save': return 'Сохранить';
			case 'income.time': return 'Время';
			case 'income.select': return 'Выбрать';
			case 'menu.menuTitle': return 'Меню';
			case 'menu.operations': return 'Все операции';
			case 'menu.operationsAll': return 'Все транзакции';
			case 'menu.operationsByCounterparties': return 'По контрагентам';
			case 'menu.operationsByAccounts': return 'По счетам';
			case 'menu.reports': return 'Отчеты';
			case 'menu.reportsByArticles': return 'Отчеты по статьям';
			case 'menu.reportsIncomeExpenseSummary': return 'Общее положение доходов и расходов';
			case 'menu.reportsMonthly': return 'Месячный отчет по доходам и расходам';
			case 'menu.reportsMetrics': return 'Показатели';
			case 'menu.settings': return 'Настройки';
			case 'menu.settingsCounterparties': return 'Контрагенты';
			case 'menu.settingsCounterpartyTypes': return 'Тип контрагентов';
			case 'menu.settingsAccounts': return 'Счета';
			case 'menu.settingsArticles': return 'Статьи';
			case 'menu.logout': return 'Выход';
			case 'menu.profile.profile': return 'Профиль';
			case 'menu.profile.next': return 'Далее';
			case 'menu.profile.deleteAccount': return 'Удалить Аккаунт';
			case 'menu.profile.account': return 'Аккаунт';
			case 'menu.error': return 'Ошибка';
			case 'menu.typeCounterparties.title': return 'Типы контрагентов';
			case 'menu.typeCounterparties.addType': return 'Добавить тип';
			case 'menu.typeCounterparties.editType': return 'Редактировать тип';
			case 'menu.typeCounterparties.print': return 'Распечатать';
			case 'menu.typeCounterparties.export': return 'Скачать в Excel';
			case 'menu.typeCounterparties.name': return 'Название';
			case 'menu.typeCounterparties.delete': return 'Удалить тип';
			case 'menu.typeCounterparties.notFound': return 'Нет типов контрагентов';
			case 'menu.save': return 'Сохранить';
			case 'menu.edit': return 'Редактировать';
			case 'menu.counterparties.title': return 'Контрагенты';
			case 'menu.counterparties.addCounterparty': return 'Добавить контрагента';
			case 'menu.counterparties.editCounterparty': return 'Редактировать контрагента';
			case 'menu.counterparties.deleteCounterparty': return 'Удалить контрагента';
			case 'menu.counterparties.print': return 'Распечатать';
			case 'menu.counterparties.export': return 'Скачать в Excel';
			case 'menu.counterparties.name': return 'Название';
			case 'menu.counterparties.type': return 'Тип';
			case 'menu.counterparties.notFound': return 'Нет контрагентов';
			case 'menu.counterparties.phoneNumber': return 'Контактная информация';
			case 'operation.operation': return 'Операции';
			case 'operation.selectPeriod': return 'Выбрать период';
			case 'operation.filter': return 'Фильтр';
			case 'operation.resetFilter': return 'Сбросить фильтр';
			case 'operation.partnerSuccessUpdate': return 'Партнер успешно обновлен!';
			case 'operation.error': return 'Ошибка';
			case 'operation.notOperation': return 'Нет операций';
			case 'operation.hasPartner': return 'Партнёр уже присвоен для этой операции';
			case 'operation.week': return 'Неделя';
			case 'operation.oneMonth': return 'За месяц';
			case 'operation.threeMonth': return 'За 3 месяца';
			case 'operation.plusPartner': return '+ Контрагент';
			case 'operation.start': return 'Начало';
			case 'operation.end': return 'Конец';
			case 'operation.show': return 'Показать';
			case 'operation.addPartner': return 'Добавить контрагента';
			case 'operation.selectTypeAndPartner': return 'Выберите тип и партнера';
			case 'operation.selectType': return 'Выберите тип';
			case 'operation.selectPartner': return 'Выберите партнера';
			case 'operation.cancel': return 'Отмена';
			case 'operation.yes': return 'Да';
			case 'operation.notFoundPartner': return 'Партнер не найден';
			default: return null;
		}
	}
}

