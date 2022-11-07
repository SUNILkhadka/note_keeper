import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper/controllers/controller.dart';
import 'package:note_keeper/core/app_theme.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isDark = prefs.getBool('themeValue');
  isDark ??= false;
  runApp(MyApp(
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  MyApp({
    super.key,
    required this.isDark,
  });
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>(
      create: (context) => AuthController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Beta Notes Keeping',
        theme: isDark ? MainAppTheme.dark : MainAppTheme.light,
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? RoutesManager.loginpage
            : RoutesManager.homepage,
        onGenerateRoute: RoutesManager.routeSettings,
      ),
    );
  }
}
