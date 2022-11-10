import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettings extends ChangeNotifier {
  ThemeSettings({
    required this.isDark,
  });

  // Theme Setting variable
  bool isDark;

  // Switch theme
  switchTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', value);
    isDark = value;
    notifyListeners();
  }
}
