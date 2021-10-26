import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/song/edit_song_form.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';

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
            Header(
                title: LocalizationService.instance.getLocalizedString('song')),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
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
