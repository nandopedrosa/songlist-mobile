import 'package:flutter/material.dart';
import 'package:songlist_mobile/util/constants.dart';

class ProgressDialog extends StatelessWidget {
  final String message;

  const ProgressDialog({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircularProgressIndicator(),
          new Text(message),
        ],
      ),
    );
  }
}
