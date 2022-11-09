import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/components/common/side_menu.dart';
import 'package:songlist_mobile/components/show/recent_shows_grid.dart';
import 'package:songlist_mobile/components/song/recent_songs_table.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/common/upgrade_screen.dart';
import 'package:songlist_mobile/screens/song/edit_song_screen.dart';
import 'package:songlist_mobile/service/app_purchases.dart';
import 'package:songlist_mobile/service/song_service.dart';
import 'package:songlist_mobile/util/responsive.dart';

import '../../util/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screens
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      Header(
                        title: "Home",
                        scaffoldKey: _scaffoldKey,
                      ),
                      SizedBox(height: defaultPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                RecentShowsGrid(),
                                SizedBox(height: defaultPadding * 3),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocalizationService.instance
                                            .getLocalizedString("recent_songs"),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: defaultPadding),
                                        //New song button
                                        child: ElevatedButton.icon(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: defaultPadding,
                                              vertical: defaultPadding / 2,
                                            ),
                                          ),
                                          onPressed: () async {
                                            _accessSongScreen();
                                          },
                                          icon: Icon(Icons.add),
                                          label: Text(
                                            LocalizationService.instance
                                                .getLocalizedString('new_song'),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: defaultPadding),
                                RecentSongsTable(),
                                SizedBox(height: defaultPadding),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _accessSongScreen() {
    // Here we check if the user has the "Pro Version" (no song limit)
    AppPurchases.checkPurchaseLocally(noSongLimitId).then(
      (isPurchased) {
        if (isPurchased) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SonglistPlusMobileApp(
                activeScreen: EditSongScreen(),
              ),
            ),
          );
        } else {
          SongService().getTotalSongs().then((total) {
            if (total >= freeSongsLimit) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpgradeScreen(),
                ),
              );
            }
          });
        }
      },
    );
  }
}
