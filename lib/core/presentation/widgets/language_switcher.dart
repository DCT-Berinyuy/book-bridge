import 'package:book_bridge/core/providers/locale_provider.dart';
import 'package:book_bridge/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  // This map could be extended to support more languages.
  // For a more scalable solution, this could be moved to a separate file
  // or a more advanced internationalization setup could be used.
  static const Map<String, String> _languageNames = {
    'en': 'English',
    'fr': 'Français',
  };

  String _getLanguageName(String code) {
    return _languageNames[code] ?? code;
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;

    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: currentLocale,
        icon: const Icon(Icons.language),
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            localeProvider.setLocale(newLocale);
          }
        },
        items: AppLocalizations.supportedLocales.map<DropdownMenuItem<Locale>>(
          (Locale locale) {
            return DropdownMenuItem<Locale>(
              value: locale,
              child: Text(_getLanguageName(locale.languageCode)),
            );
          },
        ).toList(),
      ),
    );
  }
}
