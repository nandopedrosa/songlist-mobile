import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:songlist_mobile/components/common/export_button.dart';
import 'package:songlist_mobile/components/common/header.dart';
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
  bool exportConfirmed = false;
  late Future<List<Song>> allSongs;

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
                            setState(() {
                              this.exportConfirmed = true;
                              this.allSongs = songService.exportSongs();
                            });
                          }),
                        )
                      ],
                    ),
                    if (exportConfirmed)
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Row(
                          children: [
                            FutureBuilder<List<Song>>(
                              future: this.allSongs,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Song>> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    break;
                                  case ConnectionState.waiting:
                                    return CircularProgressIndicator();
                                  case ConnectionState.active:
                                    break;
                                  case ConnectionState.done:
                                    if (snapshot.hasData) {
                                      this._export(snapshot.data!);
                                      ToastMessage.showSuccessToast(
                                          LocalizationService.instance
                                              .getLocalizedString(
                                                  "songs_exported"));
                                    } else if (snapshot.hasError) {
                                      return Expanded(
                                        child: Text(LocalizationService.instance
                                                .getLocalizedString(
                                                    "internal_error") +
                                            ':\n\n${snapshot.error}'),
                                      );
                                    }
                                }
                                return Text("");
                              },
                            )
                          ],
                        ),
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

  void _export(List<Song> songs) async {
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
