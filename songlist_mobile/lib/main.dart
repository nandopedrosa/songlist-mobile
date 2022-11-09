import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:songlist_mobile/controllers/MenuController.dart';
import 'package:songlist_mobile/screens/common/home_screen.dart';
import 'package:songlist_mobile/screens/common/main_screen.dart';
import 'package:songlist_mobile/service/app_purchases.dart';
import 'package:songlist_mobile/util/constants.dart';

void main() {
  runApp(SonglistPlusMobileApp(
    activeScreen: HomeScreen(),
    isFirstRun: true,
  ));
}

class SonglistPlusMobileApp extends StatefulWidget {
  final Widget activeScreen;
  final bool isFirstRun;

  const SonglistPlusMobileApp(
      {Key? key, required this.activeScreen, this.isFirstRun = false})
      : super(key: key);

  @override
  State<SonglistPlusMobileApp> createState() => _SonglistPlusMobileAppState();
}

class _SonglistPlusMobileAppState extends State<SonglistPlusMobileApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MenuController(),
        ),
        ChangeNotifierProvider<AppPurchases>(
          create: (context) => AppPurchases(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
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
        home:

            //Main screen is used as a template for other screens
            GestureDetector(
          // Tapping outside of text fields hides the keyboard
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: widget.isFirstRun
              ? HomeScreen()
              : MainScreen(activeScreen: this.widget.activeScreen),
        ),
      ),
    );
  }
}
