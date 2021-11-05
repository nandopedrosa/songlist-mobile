import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:songlist_mobile/components/common/export_button.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/components/common/progress_dialog.dart';
import 'package:songlist_mobile/components/common/toast_message.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/service/song_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import '../../util/constants.dart';

// ignore: must_be_immutable
class ExportDatabaseScreen extends StatefulWidget {
  ExportDatabaseScreen({Key? key}) : super(key: key);

  @override
  _ExportDatabaseScreen createState() => _ExportDatabaseScreen();
}

class _ExportDatabaseScreen extends State<ExportDatabaseScreen> {
  _ExportDatabaseScreen();

  late SongService songService;
  late Future<List<Song>> allSongsFuture;

  @override
  void initState() {
    super.initState();
    this.songService = SongService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
                title: LocalizationService.instance
                    .getLocalizedString('export_songs')),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              LocalizationService.instance.getLocalizedString(
                                  "export_database_disclaimer"),
                              style: Theme.of(context).textTheme.subtitle1!,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ExportButton(onPressed: () {
                            // First we show a "Loading Dialog"
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return ProgressDialog(
                                  message: LocalizationService.instance
                                      .getLocalizedString("exporting_songs"),
                                );
                              },
                            );
                            //Now we get all songs from the database
                            this.allSongsFuture = songService.exportSongs();
                            allSongsFuture.then((songs) {
                              // If there are songs to export, we export them to file
                              if (songs.isNotEmpty) {
                                this._export(songs).then((value) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(); // Close the dialog
                                });
                              } else {
                                // If there are no songs, we just display an error message
                                Navigator.of(context, rootNavigator: true)
                                    .pop(); // Close the dialog
                                ToastMessage.showErrorToast(
                                    LocalizationService.instance
                                        .getLocalizedString(
                                            "no_songs_to_export"),
                                    context);
                              }
                            });
                          }),
                        )
                      ],
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

  Future<void> _export(List<Song> songs) async {
    String exportedFileName = "songlist-export.json";
    String jsonListOfSongs =
        jsonEncode(songs.map((s) => Song.toMap(s)).toList());

    //Write to file
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$exportedFileName');
    await file.writeAsString(jsonListOfSongs);

    //Share to user
    Share.shareFiles(['${directory.path}/$exportedFileName']);
  }
}
