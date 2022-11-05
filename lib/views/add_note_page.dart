import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/authcontroller.dart';
import 'package:note_keeper/models/note.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({
    super.key,
    this.note,
  });
  final Note? note;

  final TextStyle titleStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: 2,
  );

  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthController>(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () async {
            NavigatorState nav = Navigator.of(context);
            await authcontroller.saveNotes(
              context,
              update: note == null ? false : true,
              note: note ?? note,
            );
            nav.pop();
          },
          child: const Icon(FontAwesomeIcons.angleLeft),
        ),
        centerTitle: true,
        title: const Text('Add Note'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: authcontroller.titlecontroller(note),
                textAlign: TextAlign.center,
                minLines: 1,
                maxLines: 30,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: titleStyle,
                ),
              ),
              TextField(
                controller: authcontroller.notecontroller(note),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '  Note',
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                maxLines: 18,
                autofocus: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
