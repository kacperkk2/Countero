import 'package:countero/pages/home.dart';
import 'package:flutter/material.dart';

enum MyRoute {
  HOME,
}

extension RouteExtension on MyRoute {
  static const routes = {
    MyRoute.HOME: '/home',
  };

  String get route => routes[this];
}

Map<String, WidgetBuilder> getRoutes() {
  return {
    MyRoute.HOME.route: (context) => Home(),
  };
}