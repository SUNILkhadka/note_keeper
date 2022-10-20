import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper/controllers/authcontroller.dart';
import 'package:note_keeper/core/app_theme.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>(
      create: (context) => AuthController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Beta Notes Keeping',
        theme: MainAppTheme.dark,
        initialRoute:  FirebaseAuth.instance.currentUser == null 
          ? RoutesManager.loginpage
          : RoutesManager.homepage,
        onGenerateRoute: RoutesManager.routeSettings,
      ),
    );
  }
}
