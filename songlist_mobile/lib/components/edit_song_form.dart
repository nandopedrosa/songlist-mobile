import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:songlist_mobile/components/save_button.dart';
import 'package:songlist_mobile/components/text_area_editor.dart';
import 'package:songlist_mobile/components/text_field_editor.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/service/song_service.dart';
import 'package:songlist_mobile/util/validation.dart';
import '../util/constants.dart';

// ignore: must_be_immutable
class EditSongForm extends StatefulWidget {
  int? songId;

  EditSongForm({
    Key? key,
    this.songId,
  }) : super(key: key);

  @override
  _EditSongForm createState() => _EditSongForm(songId);
}

class _EditSongForm extends State<EditSongForm> {
  int? songId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _tempoController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _lyricsController = TextEditingController();
  late SongService service;

  _EditSongForm(this.songId);

  @override
  void initState() {
    super.initState();
    this.service = SongService();
  }

  @override
  Widget build(BuildContext context) {
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
        TextAreaEditor(
          controller: this._lyricsController,
          label:
              LocalizationService.instance.getLocalizedString('lyrics/chords'),
        ),
        SaveButton(
          onPressed: this.saveSong,
        ),
      ],
    );
  }

  void saveSong() {
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

    Validation validation = service.validate(song);

    if (validation.isValid) {
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(defaultPadding))),
              backgroundColor: secondaryColor,
              title: Text(
                'Please, correct the errors below:',
                style: TextStyle(fontSize: defaultFontSize),
              ),
              content: Text(
                validation.getMessagesMultiline(),
                style:
                    TextStyle(fontSize: defaultFontSize, color: Colors.white54),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: defaultFontSize),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }
}