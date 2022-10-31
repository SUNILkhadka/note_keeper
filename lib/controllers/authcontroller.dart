import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_keeper/models/note.dart';

class AuthController extends ChangeNotifier {
  // TextEditing Controllers
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController notecontroller = TextEditingController();

  // firebase instances
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Varaibles used for signing in
  GoogleSignIn googleSigninObj = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future<bool> checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveNotes() async {
    if (titlecontroller.text == '' && notecontroller.text == '') return false;
    bool connSts = await checkUserConnection();
    if (!connSts) {
      print('No Internet Connection !');
      return false;
    }
    await firestore
        .collection('/${firebaseAuth.currentUser!.uid}')
        .doc()
        .set(
          Note(
            title: titlecontroller.text,
            note: notecontroller.text,
          ).toJson(),
        )
        .then((_) => print("Note Upoaded"));
    clearController();
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

  clearController() {
    titlecontroller.clear();
    notecontroller.clear();
  }

  // Snapshot to Object
  List<Note> snapshotToMap(AsyncSnapshot<QuerySnapshot>? snapshot) {
    List<Note> notes;
    notes = snapshot!.data!.docs
        .map(
          (document) => Note(
            id: document.id,
            title: document['title'],
            note: document['note'],
          ),
        )
        .toList();
    return notes;
  }
}
