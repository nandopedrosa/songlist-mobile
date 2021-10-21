import 'package:flutter/material.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/localization/localization_service.dart';

// ignore: must_be_immutable
class PlayButton extends StatelessWidget {
  final VoidCallback onPressed;
  double leftPadding;
  double rightPadding;
  double topPadding;

  PlayButton({
    Key? key,
    required this.onPressed,
    this.leftPadding = formFieldPadding,
    this.rightPadding = formFieldPadding,
    this.topPadding = formFieldPadding * 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: formFieldPadding,
          right: formFieldPadding,
          top: formFieldPadding),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: this.onPressed,
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child:
                Text(LocalizationService.instance.getLocalizedString('play'))),
      ),
    );
  }
}
