import 'package:flutter/material.dart';
import '../../util/constants.dart';

class ModalDialog extends StatelessWidget {
  final String message;
  final String title;
  final String dismissButtonText;
  final ModalDialogType type;

  const ModalDialog(
      {Key? key,
      required this.message,
      required this.title,
      required this.dismissButtonText,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
      backgroundColor: secondaryColor,
      title: Text(
        title,
        style: TextStyle(fontSize: defaultFontSize),
      ),
      content: Text(
        message,
        style: TextStyle(fontSize: defaultFontSize, color: Colors.white54),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: defaultFontSize),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            this.dismissButtonText,
            style: TextStyle(fontSize: flatButtonDefaultFontSize),
          ),
        ),
      ],
    );
  }
}

enum ModalDialogType { error, success, warning }
