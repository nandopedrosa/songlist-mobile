import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:songlist_mobile/util/constants.dart';

//Screen without the drawer menu
class SecondaryScreen extends StatefulWidget {
  final Widget activeScreen;

  const SecondaryScreen({Key? key, required this.activeScreen})
      : super(key: key);

  @override
  State<SecondaryScreen> createState() => _SecondaryScreenState();
}

class _SecondaryScreenState extends State<SecondaryScreen> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

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
        home: widget.activeScreen);
  }
}
