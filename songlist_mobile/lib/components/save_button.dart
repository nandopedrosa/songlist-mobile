import 'package:flutter/material.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/localization/localization_service.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: formFieldPadding, top: formFieldPadding * 3),
      child: ElevatedButton(
          onPressed: this.onPressed,
          child: Text(LocalizationService.instance.getLocalizedString('save'))),
    );
  }
}
