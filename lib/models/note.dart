// Note model class to store and retrive notes.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note {
  Note({
    this.id,
    required this.title,
    required this.note,
  });

  String? id;
  String title;
  String note;

  // Object to Json
  Map<String, Object> toJson() => {
        'title': title,
        'note': note,
      };


}
