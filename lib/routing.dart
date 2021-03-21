import 'package:countero/pages/info.dart';
import 'package:countero/pages/modify_cost_record.dart';
import 'package:countero/pages/create_profile.dart';
import 'package:countero/pages/home.dart';
import 'package:flutter/material.dart';

enum MyRoute {
  HOME,
  CREATE_PROFILE,
  MODIFY_COST_RECORD,
  INFO,
}

extension RouteExtension on MyRoute {
  static const routes = {
    MyRoute.HOME: '/home',
    MyRoute.CREATE_PROFILE: '/create_profile',
    MyRoute.MODIFY_COST_RECORD: '/modify_cost_record',
    MyRoute.INFO: '/info',
  };

  String get route => routes[this];
}

Map<String, WidgetBuilder> getRoutes() {
  return {
    MyRoute.HOME.route: (context) => Home(),
    MyRoute.CREATE_PROFILE.route: (context) => CreateProfile(),
    MyRoute.MODIFY_COST_RECORD.route: (context) => CreateCostRecord(),
    MyRoute.INFO.route: (context) => Info(),
  };
}