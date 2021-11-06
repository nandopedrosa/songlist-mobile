import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/back_header.dart';
import 'package:songlist_mobile/components/song/edit_song_form.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/song/all_songs_screen.dart';

import '../../util/constants.dart';

// ignore: must_be_immutable
class EditSongScreen extends StatefulWidget {
  int? songId;
  String? importedLyricsText;

  EditSongScreen({Key? key, this.songId, this.importedLyricsText})
      : super(key: key);

  @override
  _EditSongScreen createState() => _EditSongScreen(songId, importedLyricsText);
}

class _EditSongScreen extends State<EditSongScreen> {
  int? songId;
  String? importedLyricsText;

  _EditSongScreen(this.songId, this.importedLyricsText);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    BackHeader(
                        title: LocalizationService.instance
                            .getLocalizedString("song"),
                        goBack: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SonglistPlusMobileApp(
                                  activeScreen: AllSongsScreen()),
                            ),
                          );
                        }),
                    EditSongForm(
                      songId: songId,
                      importedLyricsText: this.importedLyricsText,
                    ),
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
