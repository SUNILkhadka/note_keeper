import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/authcontroller.dart';
import 'package:note_keeper/controllers/homecontroller.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/views/drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthController>(context);
    return ChangeNotifierProvider<HomeController>(
      create: (context) => HomeController(),
      child: SafeArea(
        child: Scaffold(
          drawer: const DrawerSettingPage(),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: StaggeredGrid.extent(
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 5,
                    maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                    children: notes
                        .map(
                          (note) => InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              print(note.id);
                              Navigator.pushNamed(
                                context,
                                RoutesManager.newnote,
                                arguments: Note(
                                  title: note.title,
                                  note: note.note,
                                ),
                              );
                            },
                            child: noteContainer(
                              title: Text(
                                note.title,
                                softWrap: true,
                                maxLines: 1,
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
      ),
    );
  }

  Widget noteContainer({
    required Widget title,
    required Widget subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white54,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          title,
          const SizedBox(
            height: 3,
          ),
          subtitle,
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
