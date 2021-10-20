import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:songlist_mobile/util/constants.dart';

// ignore: must_be_immutable
class TextFieldEditor extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  String? hint;
  IconData? icon;
  final int? maxLength;
  final TextInputType keyboardType;
  final bool acceptNumbersOnly;
  final Color fillColor;
  final bool filled;
  final String mask;

  TextFieldEditor({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.maxLength = 64,
    this.acceptNumbersOnly = false,
    this.fillColor = secondaryColor,
    this.filled = false,
    this.mask = 'X*', //any character
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(formFieldPadding),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: defaultFontSize),
        keyboardType: keyboardType,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
          if (this.acceptNumbersOnly) FilteringTextInputFormatter.digitsOnly,
          TextInputMask(mask: this.mask)
        ],
        decoration: InputDecoration(
          fillColor: this.fillColor,
          filled: this.filled,
          icon: icon != null ? Icon(icon) : null,
          labelText: label,
          hintText: hint != null ? hint : null,
        ),
      ),
    );
  }
}
