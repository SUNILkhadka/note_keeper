import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  
  HomeController._();
  static final HomeController _instance = HomeController._();
  factory HomeController() => _instance;


  bool longPress = false;

  alterLongPress() {
    longPress = !longPress;
  }
}
