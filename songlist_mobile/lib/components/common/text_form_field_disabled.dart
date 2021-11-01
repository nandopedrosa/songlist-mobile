import 'package:flutter/material.dart';
import 'package:songlist_mobile/util/constants.dart';

//We use this because it accepts a controller, which updates asynchronously
//We can do better next version, with a better state management
class TextFormFieldDisabled extends StatelessWidget {
  const TextFormFieldDisabled(
      {Key? key,
      required TextEditingController controller,
      TextInputType keyBoardType = TextInputType.text,
      int? maxLines = 1,
      double fontSize = defaultFontSize,
      TextAlign alignment = TextAlign.start,
      Color color = Colors.white,
      FontStyle fontStyle = FontStyle.normal})
      : _controller = controller,
        _keyBoardType = keyBoardType,
        _maxLines = maxLines,
        _fontSize = fontSize,
        _alignment = alignment,
        _color = color,
        _fontStyle = fontStyle,
        super(key: key);

  final TextEditingController _controller;
  final TextInputType _keyBoardType;
  final int? _maxLines;
  final double _fontSize;
  final FontStyle _fontStyle;
  final Color _color;
  final TextAlign _alignment;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this._controller,
      keyboardType: this._keyBoardType,
      textAlign: _alignment,
      textAlignVertical: TextAlignVertical.top,
      maxLines: this._maxLines,
      style: TextStyle(
          fontSize: this._fontSize, color: this._color, fontStyle: _fontStyle),
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
