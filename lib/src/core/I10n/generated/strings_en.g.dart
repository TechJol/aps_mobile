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
	late final TranslationsAuthEn auth = TranslationsAuthEn.internal(_root);
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

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
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
			default: return null;
		}
	}
}

