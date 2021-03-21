import 'package:countero/routing.dart';
import 'package:countero/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'models/profile_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final profileModel = ProfileModel();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => profileModel),
      ],
      child: MaterialApp(
        theme: getTheme(),
        initialRoute: MyRoute.HOME.route,
        routes: getRoutes(),
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [Locale('pl', 'PL')],
      )
    );
  }

  void loadUserData() async {
    profileModel.profile = await profileModel.loadProfile();
    profileModel.records = await profileModel.loadCostRecords();
  }
}
