// SettingPage.dart
import 'package:flutter/material.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:healthhub/Screens/locale/locale.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Importation de UiProvider.dart

class SettingPatient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String appBarTitle = Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["3"] ?? "Settings";



    return Scaffold(
      appBar: AppBar(
          title: Text(
            appBarTitle,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(LineAwesomeIcons.angle_left),
          ),

          backgroundColor: Color.fromARGB(255, 116, 180, 234)
      ),

      body: Consumer  <UiProvider>(
        builder: (context, notifier, child) {
          return Column(
            children: [
              ListTile(
                leading: ImageIcon(
                  AssetImage("lib/icons/dark.png"),
                  color: Colors.black,
                ),
                title: Text(
                    Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["4"] ?? "Dark mode"
                ),

                trailing: Switch(
                  value: notifier.isDark,
                  onChanged: (value) => notifier.changeTheme(),
                ),
              ),
              ListTile(
                title: Text(
                    Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["5"] ?? "Languages"
                ),
                trailing: DropdownButton<String>(
                  value: notifier.language, // Récupérez la langue actuelle
                  items: <String>['en', 'ar', 'fr'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    notifier.changeLanguage(newValue!); // Changez la langue
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

