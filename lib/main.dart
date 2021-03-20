import 'package:countero/routing.dart';
import 'package:countero/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getTheme(),
      initialRoute: MyRoute.HOME.route,
      routes: getRoutes(),
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [Locale('pl', 'PL')],
    );
  }
}
