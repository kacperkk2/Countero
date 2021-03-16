import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
      brightness: Brightness.dark,
      accentColor: Colors.blue[400],
      indicatorColor: Colors.green[400],
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
      ),
      tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(color: Colors.white, ),
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          )
      )
  );
}