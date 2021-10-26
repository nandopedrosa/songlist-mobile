import 'package:flutter/material.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/localization/localization_service.dart';

// ignore: must_be_immutable
class ShareSetlistButton extends StatelessWidget {
  final VoidCallback onPressed;
  double leftPadding;
  double rightPadding;
  double topPadding;

  ShareSetlistButton({
    Key? key,
    required this.onPressed,
    this.leftPadding = formFieldPadding,
    this.rightPadding = formFieldPadding,
    this.topPadding = formFieldPadding,
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
        child: ElevatedButton.icon(
          onPressed: this.onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          icon: Icon(
            Icons.ios_share,
            color: Colors.white,
          ),
          label: Text(
            LocalizationService.instance.getLocalizedString("share_setlist"),
          ),
        ),
      ),
    );
  }
}
