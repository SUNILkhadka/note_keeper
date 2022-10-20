


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier{

  // firebase instances 
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  // Varaibles used for signing in
  GoogleSignIn googleSigninObj = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;



  Future<bool> saveNotes() async {
    
    await firestore
        .collection('/users')
        .doc(firebaseAuth.currentUser!.uid)
        .set({})
        .then((_) => print("user-created"))
        .catchError((error) => print('User Creation failed $error'));
      return true;
    }




  // Methods for google sign in
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