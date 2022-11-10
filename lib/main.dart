import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper/controllers/controller.dart';
import 'package:note_keeper/controllers/note_controller.dart';
import 'package:note_keeper/controllers/them_settings.dart';
import 'package:note_keeper/core/app_theme.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences.getInstance().then((prefs) {
    var isDarkTheme = prefs.getBool("darkTheme") ?? false;

    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeSettings>(
          create: (BuildContext context) {
            return ThemeSettings(isDark: isDarkTheme);
          },
        ),
        ChangeNotifierProvider<AuthController>(
          create: ((context) => AuthController()),
        ),
        ChangeNotifierProvider<NoteController>(
          create: ((context) => NoteController()),
        )
      ],
      child: const MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeSettings>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Beta Notes Keeping',
            theme: value.isDark ? MainAppTheme.dark : MainAppTheme.light,
            initialRoute: FirebaseAuth.instance.currentUser == null
                ? RoutesManager.loginpage
                : RoutesManager.homepage,
            onGenerateRoute: RoutesManager.routeSettings,
          ),
        );
      },
    );
  }
}
