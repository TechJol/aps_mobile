class AppUpdateConfig {
  AppUpdateConfig._();

  /// Android application id as опубликовано в Google Play.
  static const String androidId = 'com.erzhi.soft_kg';

  /// Используйте bundleId или числовой Apple ID для App Store запроса.
  static const String iosId = 'com.siuu.softkg';

  /// ISO-код страны для App Store. Оставьте null для "US" по умолчанию.
  static const String iosAppStoreCountry = 'us';

  /// ISO-код страны для Play Store. Оставьте null для "US" по умолчанию.
  static const String? androidPlayStoreCountry = null;

  /// Через какое время напоминать снова, если пользователь выбрал «Позже».
  static const remindLaterInterval = Duration(days: 1);
}
