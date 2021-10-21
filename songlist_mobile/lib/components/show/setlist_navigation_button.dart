import 'package:flutter/material.dart';
import 'package:songlist_mobile/util/constants.dart';

// ignore: must_be_immutable
class SetlistNavigationButton extends StatelessWidget {
  final VoidCallback onPressed;
  double leftPad;
  double rightPad;
  double topPad;
  double bottomPad;
  String _label;

  SetlistNavigationButton(
      {Key? key,
      required this.onPressed,
      this.leftPad = formFieldPadding,
      this.rightPad = formFieldPadding,
      this.topPad = formFieldPadding,
      this.bottomPad = formFieldPadding,
      required String label})
      : this._label = label,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: leftPad, right: rightPad, top: topPad, bottom: bottomPad),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: this.onPressed, child: Text(_label)),
      ),
    );
  }
}
