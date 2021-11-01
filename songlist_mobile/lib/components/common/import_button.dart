import 'package:flutter/material.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/localization/localization_service.dart';

// ignore: must_be_immutable
class ImportButton extends StatelessWidget {
  final VoidCallback? onPressed;
  double leftPadding;
  double rightPadding;
  double topPadding;

  ImportButton({
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
          left: this.leftPadding,
          right: this.rightPadding,
          top: this.topPadding),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: this.onPressed,
            child: Text(
                LocalizationService.instance.getLocalizedString('import'))),
      ),
    );
  }
}
