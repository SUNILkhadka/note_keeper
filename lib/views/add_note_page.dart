import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/authcontroller.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatelessWidget {
  AddNoteScreen({super.key});

  TextStyle titleStyle = const TextStyle(
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
            authcontroller.saveNotes();
            Navigator.pop(context);
          },
          child: Icon(FontAwesomeIcons.angleLeft),
        ),
        centerTitle: true,
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: authcontroller.titlecontroller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: titleStyle,
              ),
            ),
            Expanded(
              child: TextField(
                controller: authcontroller.notecontroller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '  Note',
                ),
                maxLines: 18,
                autofocus: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
