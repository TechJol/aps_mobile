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
	@override late final _TranslationsAuthKy auth = _TranslationsAuthKy._(_root);
	@override late final _TranslationsHomeKy home = _TranslationsHomeKy._(_root);
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

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsKy {
	dynamic _flatMapFunction(String path) {
		switch (path) {
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
			default: return null;
		}
	}
}

