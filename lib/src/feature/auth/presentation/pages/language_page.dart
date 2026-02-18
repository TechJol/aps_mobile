// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({super.key});

  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  AppLocale? selected;

  @override
  void initState() {
    super.initState();
    selected = LocaleSettings.currentLocale;
  }

  Future<void> _applyAndGo(AppLocale locale) async {
    LocaleSettings.setLocale(locale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', locale.languageTag);

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false);
  }

  void _select(AppLocale locale) => setState(() => selected = locale);

  Widget _option({
    required BuildContext context,
    required String label,
    required String assetPath,
    required AppLocale locale,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final isSelected = selected == locale;
    return GestureDetector(
      onTap: () => _select(locale),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.primary200Color
                : scheme.outlineVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 12, backgroundImage: AssetImage(assetPath)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary200Color
                      : scheme.onSurfaceVariant,
                  width: 1,
                ),
                color: isSelected
                    ? AppColors.primary200Color
                    : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 6.5,
                        height: 6.5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final title = t.menu.language.select;
    final enLabel = t.menu.language.english;
    final ruLabel = t.menu.language.russian;
    final kyLabel = t.menu.language.kyrgyz;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: scheme.onSurface,
                fontFamily: 'Roboto',
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _option(
              context: context,
              label: enLabel,
              assetPath: 'assets/icons/uk.png',
              locale: AppLocale.en,
            ),
            _option(
              context: context,
              label: ruLabel,
              assetPath: 'assets/icons/ru.png',
              locale: AppLocale.ru,
            ),
            _option(
              context: context,
              label: kyLabel,
              assetPath: 'assets/icons/kg.png',
              locale: AppLocale.ky,
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selected != null
                    ? () => _applyAndGo(selected!)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary200Color,
                  disabledBackgroundColor: AppColors.primary50Color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  t.menu.profile.next,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
