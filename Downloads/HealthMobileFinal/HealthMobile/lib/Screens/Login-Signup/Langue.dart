import 'package:flutter/material.dart';

class AppLocalization {
  static const LocalizationsDelegate<AppLocalization> delegate =
  _AppLocalizationDelegate();

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  Map<String, Map<String, String>> translations = {
    'en': {
      'settings': 'Settings',
      'darkTheme': 'Dark theme',
    },
    'fr': {
      'settings': 'Paramètres',
      'darkTheme': 'Thème sombre',
    },
    'ar': {
      'settings': 'الإعدادات',
      'darkTheme': 'الوضع الداكن',
    },
  };

  String translate(String key) {
    return translations[locale.languageCode]![key] ?? key;
  }

  Locale locale = const Locale('en');

  void setLocale(Locale newLocale) {
    locale = newLocale;
  }
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    final localizations = AppLocalization();
    localizations.setLocale(locale);
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}
