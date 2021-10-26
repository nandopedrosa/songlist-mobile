import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:songlist_mobile/components/common/delete_button.dart';
import 'package:songlist_mobile/components/common/go_back_button.dart';
import 'package:songlist_mobile/components/common/modal_dialog.dart';
import 'package:songlist_mobile/components/common/save_button.dart';
import 'package:songlist_mobile/components/common/text_area_editor.dart';
import 'package:songlist_mobile/components/common/text_field_editor.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/screens/common/secondary_screen.dart';
import 'package:songlist_mobile/screens/song/all_songs_screen.dart';
import 'package:songlist_mobile/screens/song/import_lyrics_screen.dart';
import 'package:songlist_mobile/service/song_service.dart';
import 'package:songlist_mobile/components/common/toast_message.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/util/validation.dart';

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
  int? songId;
  String? importedLyricsText;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _tempoController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _lyricsController = TextEditingController();
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
                  Navigator.push(
                    formContext,
                    MaterialPageRoute(
                      builder: (context) => SecondaryScreen(
                        activeScreen: ImportLyricsScreen(
                          songId: this.songId!,
                        ),
                      ),
                    ),
                  );
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

  void saveOrUpdateSong() {
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

    if (validation.isValid) {
      this.service.save(song).then((id) => afterSaveOrUpdate(id));
    } else {
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

  void afterSaveOrUpdate(int id) {
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

  void delete() {
    this.service.delete(this.songId!);

    ToastMessage.showSuccessToast(LocalizationService.instance
        .getLocalizedString('song_successfully_deleted'));

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SonglistPlusMobileApp(activeScreen: AllSongsScreen())),
    );
  }
}
