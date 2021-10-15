import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/header.dart';
import 'package:songlist_mobile/components/recent_shows_grid.dart';
import 'package:songlist_mobile/components/recent_songs_table.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/util/responsive.dart';
import 'package:songlist_mobile/screens/edit_song_screen.dart';

import '../util/constants.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: "Home"),
            SizedBox(height: defaultPadding),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    RecentShowsGrid(),
                    SizedBox(height: defaultPadding * 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          LocalizationService.instance
                              .getLocalizedString("recent_songs"),
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subtitle1!,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: defaultPadding),
                          child: ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding,
                                vertical: defaultPadding /
                                    (Responsive.isMobile(context) ? 2 : 1),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SonglistPlusMobileApp(
                                    activeScreen: EditSongScreen(
                                      headerTitle: LocalizationService.instance
                                          .getLocalizedString('song'),
                                    ),
                                  ),
                                ),
                              );
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
                    SizedBox(height: defaultPadding),
                    RecentSongsTable(),
                  ],
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
