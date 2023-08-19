import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/components/common/import_button.dart';
import 'package:songlist_mobile/components/common/progress_dialog.dart';
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
  late Future<int> numberOfSongsImportedFuture;
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
                            style: Theme.of(context).textTheme.titleMedium!,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ImportButton(onPressed: () {
                            // First we show a "Loading Dialog"
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return ProgressDialog(
                                  message: LocalizationService.instance
                                      .getLocalizedString("importing_songs"),
                                );
                              },
                            );
                            // Now we import the songs from file
                            this.numberOfSongsImportedFuture = this._import();
                            numberOfSongsImportedFuture.then((value) {
                              Navigator.of(context, rootNavigator: true).pop();
                              ToastMessage.showSuccessToast(
                                  value.toString() +
                                      " " +
                                      LocalizationService.instance
                                          .getLocalizedString("songs_imported"),
                                  context);
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

  // We import the json file and return the number of songs imported.
  // In case of errors, we just return "0 songs imported".
  Future<int> _import() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null) {
      PlatformFile platformFile = result.files.first;
      File file = File(platformFile.path!);
      String jsonListOfSongs = file.readAsStringSync();
      return this.songService.importSongs(jsonListOfSongs);
    }
    return Future.value(0);
  }
}
