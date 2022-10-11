import 'package:flutter/material.dart';
import 'package:note_keeper/views/home.dart';
import 'package:note_keeper/views/login_screen.dart';

class RoutesManager {
  static const homepage = '/';
  static const loginpage = '/start';

  static Route<dynamic> routeSettings(RouteSettings settings) {
    switch (settings.name) {
      case (homepage):
        return MaterialPageRoute(builder: ((context) => HomeScreen()));

      case (loginpage):
        return MaterialPageRoute(builder: ((context) => LoginScreen()));

      default:
        throw const FormatException('Routes not found! Check the rutes');
    }
  }
}
