import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/controller.dart';
import 'package:note_keeper/controllers/note_controller.dart';
import 'package:note_keeper/controllers/them_settings.dart';
import 'package:note_keeper/core/app_color.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/views/drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authcontroller = Provider.of<AuthController>(context);
    return SafeArea(
      child: Consumer<NoteController>(
        builder: (BuildContext context, notecontroller, _) {
          return Scaffold(
            drawer: const DrawerSettingPage(),
            bottomNavigationBar: Container(
              color: Colors.transparent,
              height: 30,
            ),
            floatingActionButton: Ink(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.FABborder,
                  width: 3.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.FABborder.withOpacity(0.9),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: FloatingActionButton(
                backgroundColor: AppColor.FABbackground,
                onPressed: () {
                  Navigator.pushNamed(context, RoutesManager.newnote);
                },
                child: const Icon(
                  FontAwesomeIcons.plus,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    leading: leadingWidget(authcontroller),
                    title: titleWidget(authcontroller, notecontroller),
                    actions: actionWidgets(authcontroller, context),
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
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: authcontroller.firebaseAuth.currentUser == null
                    ? const Center(
                        child: Text('Sign in first !'),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: StreamBuilder(
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
                              notecontroller.totalNoteList =
                                  authcontroller.snapshotToMap(snapshot);
                              List<Note>? noteList =
                                  notecontroller.displayNoteList ??
                                      authcontroller.snapshotToMap(snapshot);
                              return noteBuilder(
                                  context, noteList, authcontroller);
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error refreshing !'),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.none) {
                              return const Center(
                                child: Text('No Connection '),
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
        },
      ),
    );
  }

  Padding noteBuilder(BuildContext context, List<Note> noteList,
      AuthController authcontroller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: StaggeredGrid.extent(
        crossAxisSpacing: 7,
        mainAxisSpacing: 5,
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
        children: noteList
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
                  isSelected: authcontroller.isSelectedItems.contains(note.id)
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
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: context.read<ThemeSettings>().isDark
                                ? Colors.white70
                                : Colors.black87,
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
                          ),
                        ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> actionWidgets(
      AuthController authcontroller, BuildContext context) {
    return authcontroller.isLongPress
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
              padding: const EdgeInsets.only(
                right: 10,
                top: 5,
                bottom: 5,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: authcontroller.firebaseAuth.currentUser == null
                    ? Image.asset('assets/app-image/unknown.jpg')
                    : Image.network(
                        '${authcontroller.firebaseAuth.currentUser!.photoURL}'),
              ),
            )
          ];
  }

  TextField? titleWidget(
      AuthController authcontroller, NoteController notecontroller) {
    return !authcontroller.isLongPress
        ? TextField(
            controller: notecontroller.searchController,
            onChanged: (value) {
              notecontroller.searchText(value);
            },
            style: TextStyle(color: Colors.white70),
            decoration: const InputDecoration(
              hintStyle: TextStyle(
                color: Colors.white24,
              ),
              hintText: 'Search your notes',
              border: InputBorder.none,
            ),
          )
        : null;
  }

  Padding? leadingWidget(AuthController authcontroller) {
    return authcontroller.isLongPress
        ? Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
              child: const Icon(FontAwesomeIcons.xmark),
              onPressed: () {
                authcontroller.clearLongPress();
              },
            ),
          )
        : null;
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
          color: isSelected
              ? Colors.lightGreen
              : context.read<ThemeSettings>().isDark
                  ? Colors.white54
                  : Colors.black26,
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
