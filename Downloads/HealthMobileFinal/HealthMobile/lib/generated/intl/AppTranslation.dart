import 'package:get/get.dart';

class AppTranslation extends Translations {
  static final Map<String, Map<String, String>> translations = {
    'en': {
      'setting': 'Setting',
      'dark mode': 'Dark Mode',
      'home': 'Home',
    },
    'ar': {
      'setting': 'الإعدادات',
      'dark mode': 'الوضع المظلم',
      'home': 'الصفحة الرئيسية',
    },
    'fr': {
      'setting': 'Paramètres',
      'dark mode': 'Mode sombre',
      'home': 'Accueil',
    },
  };

  @override
  Map<String, Map<String, String>> get keys => translations;
}
