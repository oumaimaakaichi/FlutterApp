import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  bool _isDark = false;
  String _language = 'en'; // Ajoutez une propriété language et initialisez-la à la langue par défaut

  bool get isDark => _isDark;
  String get language => _language; // Ajoutez un getter pour la propriété language

  void changeTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void changeLanguage(String newLanguage) { // Ajoutez une méthode pour changer la langue
    _language = newLanguage;
    notifyListeners();
  }
}
