// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsAppPage extends StatelessWidget {
  const SettingsAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = LocaleSettings.currentLocale;
    final langLabel = _langLabel(currentLocale);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: t.menu.settings,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            20.h,
            Container(
              padding: const EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.backroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок секции
                  Text(
                    t.menu.interface,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  16.h,

                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.menu.theme.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              t.menu.theme.light,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.greyColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  20.h,

                  GestureDetector(
                    onTap: () => _showLanguageSheet(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.menu.language.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              langLabel, // текущая локаль, читаемо
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.greyColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _langLabel(AppLocale locale) {
    switch (locale) {
      case AppLocale.ru:
        return t.menu.language.russian;
      case AppLocale.en:
        return t.menu.language.english;
    }
  }

  Future<void> _showLanguageSheet(BuildContext context) async {
    final current = LocaleSettings.currentLocale;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Заголовок
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    t
                        .menu
                        .language
                        .select, // "Выберите язык" / "Select a language"
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                8.h,

                _LanguageTile(
                  leading: const Text('🇷🇺', style: TextStyle(fontSize: 22)),
                  title: t.menu.language.russian,
                  selected: current == AppLocale.ru,
                  onTap: () => _applyLocale(ctx, AppLocale.ru),
                ),

                _LanguageTile(
                  leading: const Text('🇬🇧', style: TextStyle(fontSize: 22)),
                  title: t.menu.language.english,
                  selected: current == AppLocale.en,
                  onTap: () => _applyLocale(ctx, AppLocale.en),
                ),

                // KY (опционально, если есть)
                // _LanguageTile(
                //   leading: const Text('🇰🇬', style: TextStyle(fontSize: 22)),
                //   title: t.menu.language.kyrgyz,
                //   selected: current == AppLocale.ky,
                //   onTap: () => _applyLocale(ctx, AppLocale.ky),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _applyLocale(BuildContext sheetContext, AppLocale locale) async {
    LocaleSettings.setLocale(locale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', locale.languageTag);

    Navigator.of(sheetContext).pop();
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.leading,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leading,
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: onTap,
    );
  }
}
