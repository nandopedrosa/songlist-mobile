import 'package:flutter/material.dart';
import 'package:songlist_mobile/util/constants.dart';

class TextFormFieldDisabled extends StatelessWidget {
  const TextFormFieldDisabled(
      {Key? key,
      required TextEditingController controller,
      TextInputType keyBoardType = TextInputType.text,
      int? maxLines = 1,
      double fontSize = defaultFontSize,
      Color color = Colors.white})
      : _controller = controller,
        _keyBoardType = keyBoardType,
        _maxLines = maxLines,
        _fontSize = fontSize,
        _color = color,
        super(key: key);

  final TextEditingController _controller;
  final TextInputType _keyBoardType;
  final int? _maxLines;
  final double _fontSize;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this._controller,
      keyboardType: this._keyBoardType,
      maxLines: this._maxLines,
      style: TextStyle(fontSize: this._fontSize, color: this._color),
      readOnly: true,
      decoration: new InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }
}
