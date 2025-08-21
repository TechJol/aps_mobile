final class ApsKeys {
  // login
  static const loginInitial = 'login-initial';
  static const login = 'Логин';
  static const signInView = 'sign-in-view';
  static const sendOtp = 'send-otp';
  static const verifyOtpView = 'verify-otp-view';
  static const emailTextField = 'email-text-field';
  static const otpTextField = 'otp-text-field';

  // home
  static const home = 'home';
  static const homeListView = 'home-list-view';
  static const homeView = 'home-view';

  // settings
  static const settings = 'settings';
  static const settingsView = 'settings-view';
  static const settingsGenderLang = 'settings-gender-lang';
  static const settingsGenderLangPage = 'settings-gender-lang-page';
  static const settingsGenderMale = 'settings-gender-male';
  static const settingsGenderFemale = 'settings-gender-female';
  static const settingsTheme = 'settings-theme';
  static const settingsThemePage = 'settings-theme-page';
  static const settingsThemeLight = 'settings-theme-light';
  static const settingsThemeDark = 'settings-theme-dark';
  static String settingsThemeColorName(String name) => 'settings-theme-$name';
  static const settingsAboutUs = 'settings-about-us';
  static const settingsAboutUsPage = 'settings-about-us-page';
  static const settingsContactUs = 'settings-contact-us';
  static const settingsContactUsPage = 'settings-contact-us-page';
  static const settingsDevelopers = 'settings-developers';
  static const settingsDevelopersPage = 'settings-developers-page';
  static const String logoutButton = 'logout-button';
  static const String confirmLogoutButton = 'confirm-logout-button';
  static const String confirmLogoutButtonYes = 'confirm-logout-button-yes';
  static const String deleteAccountButton = 'delete-button';
  static const String confirmDeleteAccountButton =
      'confirm-delete-account-button';

  // login type
  static const loginType = 'login';
  static String loginTypeName(String name) => 'loginType-$name';

  // language
  static const language = 'language';
  static String languageCode(String localeCode) => 'language-$localeCode';

  // theme
  static const theme = 'theme';
  static String themeMode(String mode) => 'theme-$mode-mode';
  static String themeIndex(int index) => 'theme-index-$index';
}
