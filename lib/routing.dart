import 'package:countero/pages/create_profile.dart';
import 'package:countero/pages/home.dart';
import 'package:flutter/material.dart';

enum MyRoute {
  HOME,
  CREATE_PROFILE,
}

extension RouteExtension on MyRoute {
  static const routes = {
    MyRoute.HOME: '/home',
    MyRoute.CREATE_PROFILE: '/create_profile',
  };

  String get route => routes[this];
}

Map<String, WidgetBuilder> getRoutes() {
  return {
    MyRoute.HOME.route: (context) => Home(),
    MyRoute.CREATE_PROFILE.route: (context) => CreateProfile(),
  };
}