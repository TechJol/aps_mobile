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
			default: return null;
		}
	}
}

