import 'package:songlist_mobile/constants.dart';
import 'package:songlist_mobile/controllers/MenuController.dart';
import 'package:songlist_mobile/screens/home_screen.dart';
import 'package:songlist_mobile/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:songlist_mobile/screens/songs_screen.dart';

void main() {
  runApp(SonglistPlusMobileApp(activeScreen: HomeScreen()));
}

class SonglistPlusMobileApp extends StatelessWidget {
  final Widget activeScreen;

  const SonglistPlusMobileApp({
    Key? key,
    required this.activeScreen,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Songlist Plus',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
        ],
        child: MainScreen(activeScreen: this.activeScreen),
      ),
    );
  }
}
