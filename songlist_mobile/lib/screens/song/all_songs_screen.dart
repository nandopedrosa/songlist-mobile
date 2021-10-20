import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/song/all_songs_table.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/util/responsive.dart';
import 'package:songlist_mobile/screens/song/edit_song_screen.dart';
import '../../util/constants.dart';

// ignore: must_be_immutable
class AllSongsScreen extends StatefulWidget {
  @override
  _AllSongsScreenState createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
                title:
                    LocalizationService.instance.getLocalizedString('songs')),
            SizedBox(height: defaultPadding),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
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
                      ],
                    ),
                    SizedBox(height: defaultPadding),
                    AllSongsTable(),
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
