import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'dart:io' show Platform;

class ToastMessage {
  static void showSuccessToast(String message, BuildContext context) {
    if (Platform.isAndroid) {
      _showSnackBarMessage(context, message, Color.fromRGBO(25, 135, 83, 1.0));
    } else if (Platform.isIOS) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Color.fromRGBO(25, 135, 83, 1.0),
          textColor: Colors.white,
          fontSize: defaultFontSize);
    }
  }

  static void showErrorToast(String message, BuildContext context) {
    if (Platform.isAndroid) {
      _showSnackBarMessage(context, message, Color.fromRGBO(255, 67, 67, 0.8));
    } else if (Platform.isIOS) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Color.fromRGBO(255, 67, 67, 0.8),
          textColor: Colors.white,
          fontSize: defaultFontSize);
    }
  }

  static void _showSnackBarMessage(
      BuildContext context, String message, Color? backgroundColor) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 5000),
        backgroundColor: backgroundColor,
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
            textColor: Colors.white,
            label: 'OK',
            onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
