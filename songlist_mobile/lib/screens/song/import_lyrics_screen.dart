import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/back_header.dart';
import 'package:songlist_mobile/components/common/import_button.dart';
import 'package:songlist_mobile/components/common/text_field_editor.dart';
import 'package:songlist_mobile/components/common/toast_message.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/song/edit_song_screen.dart';
import 'package:songlist_mobile/service/song_service.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ImportLyricsScreen extends StatefulWidget {
  final int songId;

  const ImportLyricsScreen({Key? key, required this.songId}) : super(key: key);

  @override
  _ImportLyricsScreen createState() => _ImportLyricsScreen(songId: songId);
}

class _ImportLyricsScreen extends State<ImportLyricsScreen> {
  _ImportLyricsScreen({required this.songId});

  final int songId;
  String? _importedLyricsText;
  Future<http.Response>? apiResponse;
  late SongService songService;
  final TextEditingController _urlControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.songService = SongService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                // It takes 5/6 part of the screen
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BackHeader(
                            title: LocalizationService.instance
                                .getLocalizedString("import_lyrics_chords"),
                            goBack: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SonglistPlusMobileApp(
                                    activeScreen: EditSongScreen(
                                      songId: this.songId,
                                      importedLyricsText:
                                          this._importedLyricsText,
                                    ),
                                  ),
                                ),
                              );
                            }),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(formFieldPadding),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocalizationService.instance
                                            .getLocalizedString(
                                                "supported_websites"),
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: defaultFontSize * 1.25),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  TextFieldEditor(
                                      controller: this._urlControler,
                                      label: LocalizationService.instance
                                          .getLocalizedString(
                                              "import_web_address")),
                                  ImportButton(
                                    onPressed: () {
                                      if (this._urlControler.text.isEmpty)
                                        return;

                                      if (this.isValidUrl(
                                          this._urlControler.text)) {
                                        setState(() {
                                          this.apiResponse = this
                                              ._import(this._urlControler.text);
                                        });
                                      } else {
                                        ToastMessage.showErrorToast(
                                            LocalizationService.instance
                                                .getLocalizedString(
                                                    "website_not_supported"));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder<http.Response>(
                                future: this.apiResponse,
                                builder: (BuildContext context,
                                    AsyncSnapshot<http.Response> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      break;
                                    case ConnectionState.waiting:
                                      return CircularProgressIndicator();
                                    case ConnectionState.active:
                                      break;
                                    case ConnectionState.done:
                                      if (snapshot.hasData) {
                                        this._importedLyricsText =
                                            snapshot.data!.body.toString();
                                        return Expanded(
                                          child: Text(
                                              LocalizationService.instance
                                                  .getLocalizedString(
                                                      "lyrics_imported"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('${snapshot.error}');
                                      }
                                  }
                                  return Text("");
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  bool isValidUrl(String songUrl) {
    if (songUrl.isEmpty) return false;

    for (var site in supportedLyricsOrChordsWebsites) {
      //the list is defined in the constants file
      if (songUrl.toLowerCase().indexOf(site) != -1) return true;
    }

    return false;
  }

  Future<http.Response> _import(String songUrl) {
    String songUrl = this._urlControler.text;
    String serviceRoute = "";

    if (songUrl.toLowerCase().indexOf("letras.mus.br") != -1) {
      serviceRoute = letrasServiceRoute;
    } else if ((songUrl.toLowerCase().indexOf("lyricsfreak.com") != -1)) {
      serviceRoute = lyricsFreakServiceRoute;
    }

    return http.get(
        Uri.parse(importLyricsOrChordsApiBaseUrl + serviceRoute + songUrl));
  }
}
