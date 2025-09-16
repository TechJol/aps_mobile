class AppRegExp {
  const AppRegExp._();

  static final duration = RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$');
  static final email = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  // Username: latin letters, numbers, underscore; 3-20 chars
  static final username = RegExp(r'^[A-Za-z0-9_]{3,20}$');

  // Password: min 8, at least one letter and one digit, allow common symbols
  static final password = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+\-=?\[\]{};:"\\|,.<>\/?]{8,}$',
  );

  // Name/Surname: Cyrillic/Latin letters, spaces and hyphen; 2-50 chars
  static final personName = RegExp('^[A-Za-zА-Яа-яЁё\\-\'\\s]{2,50}\$');

  // Company: allow letters (RU/EN), digits, spaces and common punctuation; 2-100 chars
  static final companyName = RegExp('^[A-Za-zА-Яа-яЁё0-9\\s\\.,&\'()\\-]{2,100}\$');
}

