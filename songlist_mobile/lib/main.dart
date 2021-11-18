import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:songlist_mobile/controllers/MenuController.dart';
import 'package:songlist_mobile/screens/common/home_screen.dart';
import 'package:songlist_mobile/screens/common/main_screen.dart';
import 'package:songlist_mobile/util/constants.dart';

void main() {
  runApp(SonglistPlusMobileApp(activeScreen: HomeScreen()));
}

class SonglistPlusMobileApp extends StatefulWidget {
  final Widget activeScreen;

  const SonglistPlusMobileApp({Key? key, required this.activeScreen})
      : super(key: key);

  @override
  State<SonglistPlusMobileApp> createState() => _SonglistPlusMobileAppState();
}

class _SonglistPlusMobileAppState extends State<SonglistPlusMobileApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Songlist Plus',
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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
        ],
        //Main screen is used as a template for other screens
        child: GestureDetector(
            // Tapping outside of text fields hides the keyboard
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MainScreen(activeScreen: this.widget.activeScreen)),
      ),
    );
  }
}
