import 'package:flutter/material.dart';

//Colors
const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

//Fonts
//whenever possible, we increment or decrement font sizes by a factor of 8
const defaultFontSize = 16.0;
const flatButtonDefaultFontSize = 20.0;

//Paddings
const defaultPadding = 16.0;
const formFieldPadding = 8.0;
const dataTableHeadingRowHeight = 72.0;

//Misc
const int defaultRowsPerPage = 8;
const increaseAndDecreaseIconHeight = 24.0;
const Color increaseAndDecreaseIconColor = Colors.white70;
const int defaultTextFieldMaxLength = 64;

//Importing lyrics and chords
const List<String> supportedLyricsOrChordsWebsites = [
  'lyricsfreak.com',
  'letras.mus.br'
];
const String importLyricsOrChordsApiBaseUrl =
    "https://songlist-plus-mobile-api.herokuapp.com/";
const String letrasServiceRoute = "import-from-letras?url=";
const String lyricsFreakServiceRoute = "import-from-freak?url=";
