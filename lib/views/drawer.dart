import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/authcontroller.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:provider/provider.dart';

class DrawerSettingPage extends StatelessWidget {
  const DrawerSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthController>(context);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
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
          TextButton(
            onPressed: () {
              authcontroller.firebaseAuth.signOut();
              authcontroller.googleSigninObj.signOut();
              Navigator.popAndPushNamed(context, RoutesManager.loginpage);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                      Text(
                        authcontroller.firebaseAuth.currentUser!.displayName!,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
