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
	@override late final _TranslationsAuthRu auth = _TranslationsAuthRu._(_root);
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

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		switch (path) {
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
			default: return null;
		}
	}
}

