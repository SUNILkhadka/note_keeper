import 'package:flutter/material.dart';

class DrawerSettingPage extends StatelessWidget {
  const DrawerSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
    );
  }
}
