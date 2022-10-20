import 'package:flutter/material.dart';
import 'package:note_keeper/core/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.white54,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColor.backgroundshadeblue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    ));
  }
}
