import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:songlist_mobile/util/constants.dart';

class ToastMessage {
  static void showSuccessToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Color.fromRGBO(25, 135, 83, 1.0),
        textColor: Colors.white,
        fontSize: defaultFontSize);
  }

  static void showErrorToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: defaultFontSize);
  }
}
