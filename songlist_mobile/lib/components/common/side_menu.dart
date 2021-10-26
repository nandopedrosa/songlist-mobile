import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/show/all_shows_screen.dart';
import 'package:songlist_mobile/screens/song/all_songs_screen.dart';
import 'package:songlist_mobile/screens/common/home_screen.dart';
import 'package:songlist_mobile/screens/tools/tools_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
                child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Image(
                        image: AssetImage('assets/images/logo-transparent.png'),
                        fit: BoxFit.cover))),
          ),
          DrawerListTile(
            title: "Home",
            svgSrc: "assets/icons/house.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SonglistPlusMobileApp(activeScreen: HomeScreen())),
              );
            },
          ),
          DrawerListTile(
            title: LocalizationService.instance.getLocalizedString("songs"),
            svgSrc: "assets/icons/file-music.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SonglistPlusMobileApp(activeScreen: AllSongsScreen())),
              );
            },
          ),
          DrawerListTile(
            title: "Shows",
            svgSrc: "assets/icons/play-btn.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SonglistPlusMobileApp(activeScreen: AllShowsScreen())),
              );
            },
          ),
          DrawerListTile(
            title: LocalizationService.instance.getLocalizedString("tools"),
            svgSrc: "assets/icons/gear.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SonglistPlusMobileApp(activeScreen: ToolsScreen())),
              );
            },
          ),
          DrawerListTile(
            title: LocalizationService.instance.getLocalizedString("help"),
            svgSrc: "assets/icons/question-octagon.svg",
            press: () {},
          ),
          DrawerListTile(
            title: LocalizationService.instance.getLocalizedString("contact"),
            svgSrc: "assets/icons/envelope.svg",
            press: () {},
          ),
          DrawerListTile(
            title:
                LocalizationService.instance.getLocalizedString("pro_version"),
            svgSrc: "assets/icons/currency-dollar.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
