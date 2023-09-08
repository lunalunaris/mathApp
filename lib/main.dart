

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:math/UI/settings/HomeScreen.dart';

import 'generated/l10n.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'HexaCount',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          splashColor: Colors.teal,

        ),
        localizationsDelegates: const [
          // ... app-specific localization delegate[s] here
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('pl','')// English
          // ... other locales the app supports
        ],
        home:  HomeScreen());
  }
}