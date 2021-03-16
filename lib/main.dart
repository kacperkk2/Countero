import 'package:countero/pages/home.dart';
import 'package:countero/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getTheme(),
      home: Home(),
    );
  }
}
