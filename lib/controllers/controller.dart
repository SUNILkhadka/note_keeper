import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_keeper/core/app_theme.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:note_keeper/models/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  // TextEditing Controllers
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _notecontroller = TextEditingController();

  // firebase instances
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Varaibles used for signing in
  GoogleSignIn googleSigninObj = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;
  UserCredential? userCredential;

  // Theme Setting variable
  bool? isDark;

  // Controllers to update or add new note
  TextEditingController titlecontroller(Note? note) {
    if (note == null || note.id == '') {
      _titlecontroller.clear();
      return _titlecontroller;
    } else {
      _titlecontroller.text = note.title;
      return _titlecontroller;
    }
  }

  TextEditingController notecontroller(Note? note) {
    if (note == null || note.id == '') {
      _notecontroller.clear();
      return _notecontroller;
    } else {
      _notecontroller.text = note.note;
      return _notecontroller;
    }
  }

  // Method to check connections
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

  // Method to save and update notes determined by update bool flag
  Future saveNotes(
    BuildContext context, {
    bool? update,
    Note? note,
  }) async {
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    bool connSts = await checkUserConnection();
    if (!connSts) {
      messengerState.showSnackBar(
        const SnackBar(
          content: Text('No Internet Connection !'),
        ),
      );
      return false;
    }
    if (update == true) {
      if (note!.title != _titlecontroller.text ||
          note.note != _notecontroller.text) {
        firestore
            .collection('/${firebaseAuth.currentUser!.uid}')
            .doc(note.id)
            .update(
              Note(
                title: _titlecontroller.text,
                note: _notecontroller.text,
                created: FieldValue.serverTimestamp(),
              ).toJson(),
            )
            .then(
              (_) => messengerState.showSnackBar(
                const SnackBar(
                  content: Text('Updated !'),
                ),
              ),
            )
            .catchError((error) => messengerState.showSnackBar(
                  SnackBar(content: Text(error.toString())),
                ));
        return;
      } else {
        return;
      }
    }
    if (_titlecontroller.text == '' && _notecontroller.text == '') return;

    await firestore
        .collection('/${firebaseAuth.currentUser!.uid}')
        .doc()
        .set(
          Note(
            title: _titlecontroller.text,
            note: _notecontroller.text,
            created: FieldValue.serverTimestamp(),
          ).toJson(),
        )
        .then(
          (_) => messengerState.showSnackBar(
            const SnackBar(
              content: Text('Note Uploaded !'),
            ),
          ),
        );
    return true;
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

  // Selecting notes for longpress
  List<String> isSelectedItems = [];
  bool isLongPress = false;

  selectDeselectItem(String item) {
    if (!isSelectedItems.contains(item)) {
      isSelectedItems.add(item);
    } else {
      isSelectedItems.remove(item);
    }
    if (isSelectedItems.isEmpty) {
      isLongPress = false;
    }
    notifyListeners();
  }

  deleteNotes() async {
    for (String str in isSelectedItems) {
      firestore
          .collection('/${firebaseAuth.currentUser!.uid}')
          .doc(str)
          .delete();
    }
    isLongPress = false;
    notifyListeners();
  }

  clearLongPress() {
    isSelectedItems.clear();
    isLongPress = false;
    notifyListeners();
  }

  // Methods for google sign in
  Future googleSignIn(BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);

    // Add Try catch block on _callMethod function with PlatformException
    GoogleSignInAccount? googleUser = await googleSigninObj.signIn();
    if (googleUser != null) {
      _user = googleUser;
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential != null) {
        navigator.pushReplacementNamed(RoutesManager.homepage);
      }
      notifyListeners();
    } else {
      messengerState.showSnackBar(
        const SnackBar(content: Text('Signup Failed !')),
      );
      return;
    }
  }

  // Theme Setting
  // Get the current theme from sharedprefences

  getDarkBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDark = prefs.getBool('themeValue');
    return isDark;
  }

  // Switch theme
  switchTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('themeValue');
    boolValue = !boolValue!;
    prefs.setBool('themeValue', boolValue);
    notifyListeners();
  }
}
