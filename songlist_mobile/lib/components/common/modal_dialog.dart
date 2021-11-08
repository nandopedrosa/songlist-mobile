import 'package:flutter/material.dart';
import '../../util/constants.dart';

// ignore: must_be_immutable
class ModalDialog extends StatelessWidget {
  final String message;
  final String title;
  final String dismissButtonText;
  String? confirmButtonText;
  Function? confirmAction; // Function called when confirm is selected
  final ModalDialogType type; // Success, Error, Warning, etc.

  ModalDialog(
      {Key? key,
      required this.message,
      required this.title,
      required this.dismissButtonText,
      required this.type,
      this.confirmButtonText,
      this.confirmAction})
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
        // Dismiss action (just closes the dialog)
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
        //Confirm action only when it is a warning dialog
        if (this.type == ModalDialogType.warning)
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: defaultFontSize),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              this.confirmAction!();
            },
            child: Text(
              this.confirmButtonText!,
              style: TextStyle(fontSize: flatButtonDefaultFontSize),
            ),
          ),
      ],
    );
  }
}

enum ModalDialogType { error, success, warning }
