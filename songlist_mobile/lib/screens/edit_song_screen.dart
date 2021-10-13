import 'package:flutter/material.dart';

import 'package:songlist_mobile/components/all_songs_table.dart';
import 'package:songlist_mobile/components/edit_song_form.dart';
import 'package:songlist_mobile/components/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/util/responsive.dart';

import '../util/constants.dart';

// ignore: must_be_immutable
class EditSongScreen extends StatefulWidget {
  String headerTitle;
  int? songId;

  EditSongScreen({
    Key? key,
    required this.headerTitle,
    this.songId,
  }) : super(key: key);

  @override
  _EditSongScreen createState() => _EditSongScreen(headerTitle, songId);
}

class _EditSongScreen extends State<EditSongScreen> {
  String headerTitle;
  int? songId;

  _EditSongScreen(this.headerTitle, this.songId);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: this.headerTitle),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    EditSongForm(songId: songId),
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
