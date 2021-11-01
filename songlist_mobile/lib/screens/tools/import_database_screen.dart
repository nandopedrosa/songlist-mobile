import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/components/common/import_button.dart';
import 'package:songlist_mobile/components/common/toast_message.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/service/song_service.dart';
import '../../util/constants.dart';

// ignore: must_be_immutable
class ImportDatabaseScreen extends StatefulWidget {
  ImportDatabaseScreen({Key? key}) : super(key: key);

  @override
  _ImportDatabaseScreen createState() => _ImportDatabaseScreen();
}

class _ImportDatabaseScreen extends State<ImportDatabaseScreen> {
  _ImportDatabaseScreen();

  late SongService songService;
  bool importConfirmed = false;
  late Future<int> numberOfSongsImported;

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
                    .getLocalizedString('import_songs')),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            LocalizationService.instance.getLocalizedString(
                                "import_database_disclaimer"),
                            style: Theme.of(context).textTheme.subtitle1!,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ImportButton(onPressed: () {
                            setState(() {
                              this.importConfirmed = true;
                              this.numberOfSongsImported = this._import();
                            });
                          }),
                        )
                      ],
                    ),
                    if (importConfirmed)
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Row(
                          children: [
                            FutureBuilder<int>(
                              future: numberOfSongsImported,
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    break;
                                  case ConnectionState.waiting:
                                    return CircularProgressIndicator();
                                  case ConnectionState.active:
                                    break;
                                  case ConnectionState.done:
                                    if (snapshot.hasData) {
                                      ToastMessage.showSuccessToast(
                                          snapshot.data!.toString() +
                                              " " +
                                              LocalizationService.instance
                                                  .getLocalizedString(
                                                      "songs_imported"));
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

  Future<int> _import() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null) {
      PlatformFile platformFile = result.files.first;
      File file = File(platformFile.path!);
      String jsonListOfSongs = file.readAsStringSync();
      return this.songService.importSongs(jsonListOfSongs);
    } else {
      return 0 as Future<int>;
    }
  }
}
