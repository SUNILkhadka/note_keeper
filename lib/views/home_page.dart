import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/authcontroller.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/views/drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthController>(context);
    return SafeArea(
      child: Scaffold(
        drawer: !authcontroller.isLongPress ? const DrawerSettingPage() : null,
        appBar: AppBar(
          centerTitle: true,
          leading: authcontroller.isLongPress
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextButton(
                    child: const Icon(FontAwesomeIcons.xmark),
                    onPressed: () {
                      authcontroller.clearLongPress();
                    },
                  ),
                )
              : null,
          title: !authcontroller.isLongPress
              ? const TextField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.white24,
                    ),
                    hintText: 'Search your notes',
                    border: InputBorder.none,
                  ),
                )
              : null,
          actions: authcontroller.isLongPress
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: TextButton(
                      child: const Icon(FontAwesomeIcons.check),
                      onPressed: () {
                        authcontroller.deleteNotes();
                      },
                    ),
                  )
                ]
              : null,
        ),
        bottomNavigationBar: Container(
          height: 30,
          // color: Colors.white38,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, RoutesManager.newnote);
          },
          child: const Icon(
            FontAwesomeIcons.plus,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: authcontroller.firebaseAuth.currentUser == null
            ? const Center(
                child: Text('Sign in first !'),
              )
            : StreamBuilder(
                stream: authcontroller.firestore
                    .collection(
                        '/${authcontroller.firebaseAuth.currentUser!.uid}')
                    .orderBy('created', descending: true)
                    .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.hasData) {
                    List<Note> notes = authcontroller.snapshotToMap(snapshot);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: StaggeredGrid.extent(
                        crossAxisSpacing: 7,
                        mainAxisSpacing: 5,
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width / 2,
                        children: notes
                            .map(
                              (note) => InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  if (!authcontroller.isLongPress) {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesManager.newnote,
                                      arguments: note,
                                    );
                                  } else {
                                    authcontroller.selectDeselectItem(note.id!);
                                  }
                                },
                                onLongPress: () {
                                  authcontroller.isLongPress = true;
                                  authcontroller.selectDeselectItem(note.id!);
                                },
                                child: noteContainer(
                                  context,
                                  isSelected: authcontroller.isSelectedItems
                                          .contains(note.id)
                                      ? true
                                      : false,
                                  title: Text(
                                    note.title,
                                    softWrap: true,
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    note.note,
                                    maxLines: 10,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white54),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error refreshing !'),
                    );
                  } else {
                    return const Center(
                      child: Text('Loading...'),
                    );
                  }
                },
              ),
      ),
    );
  }

  Widget noteContainer(
    BuildContext context, {
    required bool isSelected,
    required Widget title,
    required Widget subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.pink,
        border: Border.all(
          color: isSelected ? Colors.lightGreen : Colors.white54,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: title,
            color: Colors.green,
          ),
          const SizedBox(
            height: 3,
          ),
          Container(
            child: subtitle,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Future<bool?> deleteAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("DELETE")),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }
}
