import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/controllers/authcontroller.dart';
import 'package:note_keeper/core/routes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authcontroller = Provider.of<AuthController>(context);
    return SafeArea(
      child: Scaffold(
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
            AsyncSnapshot snapshot,
          ) {
            if (snapshot.hasData) {
              return ListTile();
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error refreshing !'),
              );
            } else {
              return Center(
                child: Text('Loading...'),
              );
            }
          },
        ),
      ),
    );
  }
}
