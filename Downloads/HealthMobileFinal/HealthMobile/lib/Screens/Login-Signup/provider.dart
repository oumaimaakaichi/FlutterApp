// UiProvider.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthhub/Screens/locale/locale.dart';

class UiProvider extends ChangeNotifier {
  bool _isDark = false;
  String _language = 'en'; // Définissez la langue par défaut
  bool get isDark => _isDark;
  String get language => _language;

  final darkTheme = ThemeData(
    primaryColor: Colors.black12,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black12,
  );

  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    primaryColorDark: Colors.white,
  );

  changeTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  changeLanguage(String language) {
    _language = language;
    Get.updateLocale(Locale(language)); // Mettre à jour la langue de l'application
    notifyListeners();
  }

  init() async {
    // Vos initialisations ici
  }

  // Méthode pour obtenir les traductions en fonction de la langue
  Translations getLocale() {
    switch (_language) {
      case 'en':
        return MyLocaleEn();
      case 'fr':
        return MyLocaleFr();
      case 'ar':
        return MyLocaleAr();
      default:
        return MyLocaleEn(); // Par défaut, retournez les traductions anglaises
    }
  }

}
