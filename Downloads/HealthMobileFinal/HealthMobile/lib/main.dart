// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:healthhub/Screens/Login-Signup/welcomepage.dart';
import 'package:healthhub/generated/intl/AppTranslation.dart';
import 'package:healthhub/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:healthhub/Screens/Login-Signup/provider.dart'; // Importez votre classe UiProvider
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Activer Firebase App Check avec la clé de site reCAPTCHA pour le web

  runApp(Health());
}

class Health extends StatelessWidget {
  const Health({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UiProvider()..init()),
      ],
      child: Consumer(builder: (context, UiProvider uiProvider, _) {
        final ThemeData theme = uiProvider.isDark ? uiProvider.darkTheme : uiProvider.lightTheme;

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dark Mode',
          theme: theme,
          home: const HealthApp(),
          translationsKeys: AppTranslation.translations,
          locale: Locale(uiProvider.language), // Utiliser la langue sélectionnée
          fallbackLocale: Locale('en', 'US'),
          localizationsDelegates: [
            AppLocalizationDelegate(), // Ajouter le délégué de localisation
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        );
      }),
    );
  }
}



class HealthApp extends StatelessWidget {
  const HealthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return const Welcome(); // Vous devrez remplacer ceci par votre widget d'accueil approprié
    });
  }
}
