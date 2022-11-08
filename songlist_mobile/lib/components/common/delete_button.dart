import 'package:flutter/material.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/localization/localization_service.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({Key? key, required this.onPressed}) : super(key: key);

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
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(255, 67, 67, 0.8),
            ),
            onPressed: this.onPressed,
            child: Text(
                LocalizationService.instance.getLocalizedString('delete'))),
      ),
    );
  }
}
