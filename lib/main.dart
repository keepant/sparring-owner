import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sparring_owner/i18n.dart';
import 'package:sparring_owner/services/auth_check.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const I18nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('id', 'ID'), // Bahasa
      ],
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'nunito',
      ),
      home: AuthCheck(),
    );
  }
}