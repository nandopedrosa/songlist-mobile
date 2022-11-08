import 'package:flutter/material.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/localization/localization_service.dart';

class GoBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoBackButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: formFieldPadding,
          right: formFieldPadding,
          top: formFieldPadding),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
            onPressed: this.onPressed,
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white70,
                side: BorderSide(color: Colors.white54)),
            child:
                Text(LocalizationService.instance.getLocalizedString('back'))),
      ),
    );
  }
}
