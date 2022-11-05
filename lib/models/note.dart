// Note model class to store and retrive notes.

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  Note({
    this.id,
    required this.title,
    required this.note,
    this.created,
  });

  String? id;
  String title;
  String note;
  FieldValue? created;

  // Object to Json
  Map<String, Object> toJson() => {
        'title': title,
        'note': note,
        'created': created!,
      };
}
