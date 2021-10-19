import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:songlist_mobile/util/constants.dart';

class SecondaryScreen extends StatelessWidget {
  final Widget activeScreen;

  const SecondaryScreen({Key? key, required this.activeScreen})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            //Card theme is used for DataTables and PaginatedDataTables
            cardTheme: CardTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)))),
            dataTableTheme: DataTableThemeData(),
            scaffoldBackgroundColor: bgColor,
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            canvasColor: secondaryColor,
            cardColor: secondaryColor,
            hintColor: Colors.white),
        home: activeScreen);
  }
}
