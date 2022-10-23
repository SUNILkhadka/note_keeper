import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/authcontroller.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/views/drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthController>(context);
    return SafeArea(
      child: Scaffold(
        drawer: DrawerSettingPage(),
        appBar: AppBar(
          centerTitle: true,
          title: const TextField(
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Colors.white24,
              ),
              hintText: 'Search',
              border: InputBorder.none,
            ),
          ),
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
        body: StreamBuilder(
          stream: authcontroller.firestore
              .collection('/${authcontroller.firebaseAuth.currentUser!.uid}')
              .snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (snapshot.hasData) {
              List<Note> notes = authcontroller.snapshotToMap(snapshot);
              return ListView.builder(
                  itemBuilder: (context, index) => Dismissible(
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                    "Are you sure you wish to delete this item?"),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("DELETE")),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            notes.removeAt(direction.index);
                          }
                          if (direction == DismissDirection.endToStart) {
                            notes.removeAt(direction.index);
                          }
                        },
                        key: Key(notes[index].id!),
                        child: ListTile(
                          title: Text(
                            notes[index].title,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            notes[index].note,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  // separatorBuilder: ((context, _) => const SizedBox()),
                  itemCount: notes.length);
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
}
