import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_keeper/core/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Container(),
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
    ));
  }
}
