import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/controller.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:provider/provider.dart';

class DrawerSettingPage extends StatelessWidget {
  DrawerSettingPage({super.key});
  bool? isDark;

  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthController>(context);
    isDark = authcontroller.getDarkBool();
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  'Notes Keeper',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Divider(
                height: 1.5,
                color: Colors.white54,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Switch Theme'),
                        Switch.adaptive(
                            value: isDark!,
                            onChanged: (value) {
                              print(isDark);
                              print(value);
                              isDark = value;
                            })
                      ],
                    ),
                    signOutButton(authcontroller, context),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
            child: Text(
              'Logged in as ${authcontroller.firebaseAuth.currentUser!.displayName!}',
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  TextButton signOutButton(
      AuthController authcontroller, BuildContext context) {
    return TextButton(
      onPressed: () {
        authcontroller.firebaseAuth.signOut();
        authcontroller.googleSigninObj.signOut();
        Navigator.popAndPushNamed(context, RoutesManager.loginpage);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.rightFromBracket),
              const SizedBox(
                width: 15,
              ),
              const Text('Sign out '),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
