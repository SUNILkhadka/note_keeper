import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';

class NoteController extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  List<Note>? totalNoteList;
  List<Note>? displayNoteList;

  searchText(String text) {
    displayNoteList = totalNoteList!
        .where((element) =>
            element.title.toLowerCase().contains(text.toLowerCase()) ||
            element.note.toLowerCase().contains(text.toLowerCase()))
        .toList();
    if (text == '') {
      displayNoteList = null;
    }
    notifyListeners();
  }
}
