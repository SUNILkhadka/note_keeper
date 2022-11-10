import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/controller.dart';
import 'package:note_keeper/core/app_color.dart';
import 'package:note_keeper/core/app_text_style.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AppTextStyle textStyle = AppTextStyle.instance;

  @override
  Widget build(BuildContext context) {
    AuthController authcontroller =
        Provider.of<AuthController>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Image.asset(
                  'assets/app-icon/note.png',
                  height: 180,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hey There,\nWelcome !',
                    style: TextStyle(
                        fontSize: 36,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '''Login with your google account so, 
                    \nthat you can access notes from anywhere.''',
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              ),
              Column(
                children: [
                  // mainButton(
                  //   context,
                  //   text: "Continue Without Signing",
                  //   iconData: Icons.home,
                  //   onPressed: () {
                  //     Navigator.popAndPushNamed(
                  //         context, RoutesManager.homepage);
                  //   },
                  //   backgroundColor: AppColor.background,
                  //   textColor: Colors.white,
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  mainButton(
                    context,
                    text: "Signin with Google",
                    iconData: FontAwesomeIcons.google,
                    onPressed: () async {
                      await authcontroller.googleSignIn(context);
                    },
                    iconColor: Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox mainButton(
    BuildContext context, {
    required String text,
    required IconData iconData,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Colors.white60,
          backgroundColor: backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(
          iconData,
          color: iconColor,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
