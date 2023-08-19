import 'package:flutter/material.dart';

class CustomMenuController extends ChangeNotifier {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu(GlobalKey<ScaffoldState>? key) {
    if (key != null) {
      if (key.currentState!.isDrawerOpen) {
        key.currentState!.closeDrawer();
      } else {
        key.currentState!.openDrawer();
      }
    } else {
      if (!_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openDrawer();
      }
    }
  }
}
