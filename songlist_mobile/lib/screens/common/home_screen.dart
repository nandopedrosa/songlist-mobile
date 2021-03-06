import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/components/show/recent_shows_grid.dart';
import 'package:songlist_mobile/components/song/recent_songs_table.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/song/edit_song_screen.dart';

import '../../util/constants.dart';

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
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Row(
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
                            //New song button
                            child: ElevatedButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding,
                                  vertical: defaultPadding / 2,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SonglistPlusMobileApp(
                                      activeScreen: EditSongScreen(),
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
                    ),
                    SizedBox(height: defaultPadding),
                    RecentSongsTable(),
                    SizedBox(height: defaultPadding),
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
