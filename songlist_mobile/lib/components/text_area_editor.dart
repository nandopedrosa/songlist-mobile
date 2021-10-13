import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:songlist_mobile/util/constants.dart';

// ignore: must_be_immutable
class TextAreaEditor extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;

  const TextAreaEditor(
      {Key? key, required this.controller, required this.label, this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(formFieldPadding),
      child: TextField(
        keyboardType: TextInputType.multiline,
        controller: this.controller,
        maxLength: null,
        maxLines: null,
        decoration: InputDecoration(labelText: this.label, hintText: this.hint),
      ),
    );
  }
}
