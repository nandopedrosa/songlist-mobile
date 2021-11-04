import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:songlist_mobile/components/common/delete_button.dart';
import 'package:songlist_mobile/components/common/go_back_button.dart';
import 'package:songlist_mobile/components/common/import_button.dart';
import 'package:songlist_mobile/components/common/modal_dialog.dart';
import 'package:songlist_mobile/components/common/save_button.dart';
import 'package:songlist_mobile/components/common/text_area_editor.dart';
import 'package:songlist_mobile/components/common/text_field_editor.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/screens/song/all_songs_screen.dart';
import 'package:songlist_mobile/service/song_service.dart';
import 'package:songlist_mobile/components/common/toast_message.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/util/internet_connection.dart';
import 'package:songlist_mobile/util/validation.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class EditSongForm extends StatefulWidget {
  int? songId;
  String? importedLyricsText;

  EditSongForm({Key? key, this.songId, this.importedLyricsText})
      : super(key: key);

  @override
  _EditSongForm createState() => _EditSongForm(songId, importedLyricsText);
}

class _EditSongForm extends State<EditSongForm> {
  int? songId; // If we are updating a previously added song, this is never null
  String? importedLyricsText; // We get this after importing lyrics from the web
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _tempoController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _lyricsController = TextEditingController();
  final TextEditingController _urlControler = TextEditingController();
  Future<http.Response>? apiResponse;

  final _importButtonKey = GlobalKey();
  late SongService service;

  _EditSongForm(this.songId, this.importedLyricsText);

  @override
  void initState() {
    super.initState();
    this.service = SongService();
    if (this.songId != null) {
      service.find(songId!).then((song) => this._updateControllers(song));
    }
  }

  //Update the controller values when we fetch the model
  void _updateControllers(Song song) {
    this._titleController.text = song.title;
    this._artistController.text = song.artist;
    if (song.key != null) this._keyController.text = song.key!;
    if (song.tempo != null) this._tempoController.text = song.tempo!.toString();
    if (song.duration != null) this._durationController.text = song.duration!;
    if (song.notes != null) this._notesController.text = song.notes!;

    //If we are importing lyrics, then get the imported lyrics value
    //Else we just get whatever the DB returned
    if (this.importedLyricsText != null) {
      this._lyricsController.text = this.importedLyricsText!;
    } else {
      if (song.lyrics != null) this._lyricsController.text = song.lyrics!;
    }
  }

  @override
  Widget build(BuildContext formContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFieldEditor(
          controller: _titleController,
          label: LocalizationService.instance.getLocalizedString('title'),
        ),
        TextFieldEditor(
          controller: _artistController,
          label: LocalizationService.instance.getLocalizedString('artist'),
        ),
        TextFieldEditor(
          controller: _keyController,
          label: LocalizationService.instance.getLocalizedString('key'),
        ),
        TextFieldEditor(
          controller: _tempoController,
          label: LocalizationService.instance.getLocalizedString('tempo'),
          keyboardType: TextInputType.number,
          acceptNumbersOnly: true,
          maxLength: 3,
        ),
        TextFieldEditor(
          controller: _durationController,
          label: LocalizationService.instance.getLocalizedString('duration'),
          keyboardType: TextInputType.number,
          mask: "99:99",
          acceptNumbersOnly: true,
        ),
        TextAreaEditor(
          controller: this._notesController,
          label: LocalizationService.instance.getLocalizedString('notes'),
        ),
        Padding(
          padding: const EdgeInsets.all(formFieldPadding),
          child: Row(
            children: [
              Text(
                LocalizationService.instance
                        .getLocalizedString("import_lyrics_chords") +
                    " ?",
                style: Theme.of(context).textTheme.headline6,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                tooltip: 'Import Lyrics/Chords',
                onPressed: () {
                  //------ Modal Dialog: Import Lyrics ---------
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(defaultPadding))),
                          backgroundColor: secondaryColor,
                          title: Text(
                            LocalizationService.instance
                                .getLocalizedString("import_lyrics_chords"),
                            style: TextStyle(fontSize: defaultFontSize),
                          ),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SupportedWebsites(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        TextFieldEditor(
                                            controller: this._urlControler,
                                            maxLength: 256,
                                            label: LocalizationService.instance
                                                .getLocalizedString(
                                                    "import_web_address")),
                                        //------ IMPORT LYRICS HERE ---------
                                        ImportButton(
                                          key: _importButtonKey,
                                          onPressed: _importButtonAction,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    const TextStyle(fontSize: defaultFontSize),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    fontSize: flatButtonDefaultFontSize),
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
        TextAreaEditor(
          controller: this._lyricsController,
          label:
              LocalizationService.instance.getLocalizedString('lyrics/chords'),
        ),
        SaveButton(
          onPressed: this.saveOrUpdateSong,
        ),
        GoBackButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SonglistPlusMobileApp(activeScreen: AllSongsScreen())),
          );
        }),
        if (this.songId != null) DeleteButton(onPressed: this.delete),
      ],
    );
  }

  //Save button action
  void saveOrUpdateSong() {
    //This is used for the created_on (which is really a last modified date)
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String nowFormattedDate = formatter.format(now);

    Song song = Song(
        title: this._titleController.text,
        artist: this._artistController.text,
        key: this._keyController.text,
        tempo: this._tempoController.text.isNotEmpty
            ? int.parse(this._tempoController.text)
            : null,
        duration: this._durationController.text,
        lyrics: this._lyricsController.text,
        notes: this._notesController.text,
        created_on: nowFormattedDate);

    //We are updating
    if (this.songId != null) {
      song.id = songId;
    }

    Validation validation = service.validate(song);

    //If valid, show success Toast
    if (validation.isValid) {
      this.service.save(song).then((id) => showSaveOrUpdateSuccessMessage(id));
    } else {
      // Else, show a modal dialog with an error report
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ModalDialog(
              type: ModalDialogType.error,
              title: LocalizationService.instance
                  .getLocalizedString('found_errors'),
              message: validation.getMessagesMultiline(),
              dismissButtonText: "OK",
            );
          });
    }
  }

  void showSaveOrUpdateSuccessMessage(int id) {
    if (this.songId == null) {
      ToastMessage.showSuccessToast(LocalizationService.instance
          .getLocalizedString('song_successfully_created'));
    } else {
      ToastMessage.showSuccessToast(LocalizationService.instance
          .getLocalizedString('song_successfully_updated'));
    }

    setState(() {
      this.songId = id;
    });
  }

  //Deletes the song and goes back to the songs table
  //This is only accessible if there is a song ID
  void delete() {
    this.service.delete(this.songId!).then((value) {
      // If true, delete was sucessful, just show success message and return to the songs table
      if (value == true) {
        ToastMessage.showSuccessToast(LocalizationService.instance
            .getLocalizedString('song_successfully_deleted'));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SonglistPlusMobileApp(activeScreen: AllSongsScreen())),
        );
      } else {
        // If false, we could not delete because the song is already associated with one or more setlists
        ToastMessage.showErrorToast(LocalizationService.instance
            .getLocalizedString("cant_delete_song"));
      }
    });
  }

  // Validates import lyrics URL
  bool isValidUrl(String songUrl) {
    if (songUrl.isEmpty) return false;

    for (var site in supportedLyricsOrChordsWebsites) {
      //the list is defined in the constants file
      if (songUrl.toLowerCase().indexOf(site) != -1) return true;
    }

    return false;
  }

  //Imports a song lyrics from the web API
  void _importButtonAction() {
    if (this._urlControler.text.isEmpty) return;

    // We can only import lyrics if there is an internet connection
    InternetConnection.hasConnection().then(
      (hasConnection) {
        if (hasConnection) {
          if (this.isValidUrl(this._urlControler.text)) {
            this._importLyrics(this._urlControler.text).then(
              (value) {
                this._lyricsController.text = value.body.toString();

                ToastMessage.showSuccessToast(LocalizationService.instance
                    .getLocalizedString("lyrics_imported"));
              },
            );
          } else {
            ToastMessage.showErrorToast(LocalizationService.instance
                .getLocalizedString("website_not_supported"));
          }
        } else {
          ToastMessage.showErrorToast(
              LocalizationService.instance.getLocalizedString("no_connection"));
        }
      },
    );
  }

  //Calls the web api
  Future<http.Response> _importLyrics(String songUrl) {
    String songUrl = this._urlControler.text;
    String serviceRoute = "";

    if (songUrl.toLowerCase().indexOf("letras.mus.br") != -1) {
      serviceRoute = letrasServiceRoute;
    } else if ((songUrl.toLowerCase().indexOf("lyricsfreak.com") != -1)) {
      serviceRoute = lyricsFreakServiceRoute;
    }
    String fullUrl = importLyricsOrChordsApiBaseUrl + serviceRoute + songUrl;
    return http.get(Uri.parse(fullUrl));
  }
}

//Supported websites disclaimer
class SupportedWebsites extends StatelessWidget {
  const SupportedWebsites({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(formFieldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  LocalizationService.instance
                      .getLocalizedString("supported_websites"),
                  style: TextStyle(
                      color: Colors.white54, fontSize: defaultFontSize),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
