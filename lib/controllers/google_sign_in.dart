import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authcontroller extends ChangeNotifier {
  GoogleSignIn googleSigninObj = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleSignIn() async {
    final googleUser = await googleSigninObj.signIn();

    if (googleUser == null) return;

    _user = googleUser;

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }
}
