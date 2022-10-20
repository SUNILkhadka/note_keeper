import 'package:flutter/material.dart';
import 'package:note_keeper/views/add_note_page.dart';
import 'package:note_keeper/views/home_page.dart';
import 'package:note_keeper/views/login_page.dart';

class RoutesManager {
  static const homepage = '/';
  static const loginpage = '/start';
  static const newnote = '/newnote';

  static Route<dynamic> routeSettings(RouteSettings settings) {
    switch (settings.name) {
      case (homepage):
        return MaterialPageRoute(builder: ((context) => HomeScreen()));

      case (loginpage):
        return MaterialPageRoute(builder: ((context) => LoginScreen()));    

      case (newnote):
        return MaterialPageRoute(builder: ((context) => AddNoteScreen()));

      default:
        throw const FormatException('Routes not found! Check the rutes');
    }
  }
}
