import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/controller.dart';
import 'package:note_keeper/core/app_color.dart';
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
    fontWeight: FontWeight.w500,
    letterSpacing: 2,
  );
  final TextStyle textStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: 1,
  );

  @override
  Widget build(BuildContext context) {
    AuthController authcontroller = Provider.of<AuthController>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.FABbackground,
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
          title: Text(
            note == null ? 'Add Note' : 'Update Note',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              children: [
                TextField(
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  controller: authcontroller.titlecontroller(note),
                  minLines: 1,
                  maxLines: 30,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: titleStyle,
                  ),
                ),
                TextField(
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  controller: authcontroller.notecontroller(note),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note',
                  ),
                  style: textStyle,
                  maxLength: 5000,
                  maxLines: null,
                  autofocus: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
