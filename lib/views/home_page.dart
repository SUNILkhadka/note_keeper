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
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthController>(context);
    return SafeArea(
      child: Scaffold(
        key: _key,
        drawer: const DrawerSettingPage(),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          height: 30,
        ),
        // bottomNavigationBar: BottomAppBar(
        //   notchMargin: 4,
        //   shape: CircularNotchedRectangle(),
        //   child: Container(
        //     height: 50,
        //   ),
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, RoutesManager.newnote);
          },
          child: const Icon(
            FontAwesomeIcons.plus,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
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
                    //       : TextButton(
                    //           onPressed: () => _key.currentState!.openDrawer(),
                    //           child: const Icon(
                    //             FontAwesomeIcons.bars,
                    //             size: 18,
                    //           ),
                    //         ),
                    // ),
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
                            child: const Icon(FontAwesomeIcons.trash),
                            onPressed: () async {
                              bool? status = await deleteAlert(context);
                              if (status!) {
                                authcontroller.deleteNotes();
                              }
                            },
                          ),
                        )
                      ]
                    : [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            backgroundImage: authcontroller
                                        .firebaseAuth.currentUser ==
                                    null
                                ? null
                                : NetworkImage(
                                    '${authcontroller.firebaseAuth.currentUser!.photoURL}'),
                          ),
                        )
                      ],
                centerTitle: false,
                elevation: 5.0,
                titleSpacing: 0,
                expandedHeight: 50,
                floating: true,
                snap: true,
                stretch: false,
              )
            ];
          },
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: authcontroller.firebaseAuth.currentUser == null
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
                        List<Note> notes =
                            authcontroller.snapshotToMap(snapshot);
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
                                        authcontroller
                                            .selectDeselectItem(note.id!);
                                      }
                                    },
                                    onLongPress: () {
                                      authcontroller.isLongPress = true;
                                      authcontroller
                                          .selectDeselectItem(note.id!);
                                    },
                                    child: noteContainer(
                                      context,
                                      isSelected: authcontroller.isSelectedItems
                                              .contains(note.id)
                                          ? true
                                          : false,
                                      title: note.title == ''
                                          ? null
                                          : Text(
                                              note.title,
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                      subtitle: note.note == ''
                                          ? null
                                          : Text(
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
      ),
    );
  }

  Widget noteContainer(
    BuildContext context, {
    required bool isSelected,
    Widget? title,
    Widget? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.lightGreen : Colors.white54,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: title,
          ),
          const SizedBox(
            height: 3,
          ),
          Container(
            child: subtitle,
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
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("DELETE")),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }
}
