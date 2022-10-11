import 'package:flutter/material.dart';
import 'package:note_keeper/core/app_theme.dart';
import 'package:note_keeper/views/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beta Notes Keeping',
      theme: MainAppTheme.dark,
      home: const LoginScreen(),
    );
  }
}
