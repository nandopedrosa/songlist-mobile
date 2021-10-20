import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:songlist_mobile/components/common/delete_button.dart';
import 'package:songlist_mobile/components/common/go_back_button.dart';
import 'package:songlist_mobile/components/common/modal_dialog.dart';
import 'package:songlist_mobile/components/common/save_button.dart';
import 'package:songlist_mobile/components/common/text_area_editor.dart';
import 'package:songlist_mobile/components/common/text_field_editor.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/models/show.dart';
import 'package:songlist_mobile/screens/show/all_shows_screen.dart';
import 'package:songlist_mobile/screens/show/manage_setlist_screen.dart';
import 'package:songlist_mobile/screens/common/secondary_screen.dart';
import 'package:songlist_mobile/service/setlist_service.dart';
import 'package:songlist_mobile/service/show_service.dart';
import 'package:songlist_mobile/components/common/toast_message.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/util/validation.dart';

// ignore: must_be_immutable
class EditShowForm extends StatefulWidget {
  int? showId;
  String whenLabel;

  EditShowForm({Key? key, this.showId, required this.whenLabel})
      : super(key: key);

  @override
  _EditShowForm createState() => _EditShowForm(showId, whenLabel);
}

class _EditShowForm extends State<EditShowForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _whenController = TextEditingController();
  final TextEditingController _payController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  int? showId;
  late String whenLabel;
  late ShowService showService;
  late SetlistService setlistService;
  late Future<int> numberOfSongs;
  late Future<String> totalDuration;

  _EditShowForm(int? showId, String whenLabel) {
    this.showId = showId;
    this.whenLabel = whenLabel;
  }

  //Update the controller values when we fetch the model
  void _updateControllers(Show show) {
    this._nameController.text = show.name;
    if (show.when != null) {
      this._whenController.text = show.when!;
    }
    if (show.pay != null) this._payController.text = show.pay!;
    if (show.address != null) this._addressController.text = show.address!;
    if (show.contact != null) this._contactController.text = show.contact!;
    if (show.notes != null) this._notesController.text = show.notes!;
  }

  @override
  void initState() {
    super.initState();
    this.showService = ShowService();
    this.setlistService = SetlistService();
    if (this.showId != null) {
      showService.find(showId!).then((show) => this._updateControllers(show));
      this.numberOfSongs = setlistService.getNumberOfSongs(this.showId!);
      this.totalDuration = showService.getDuration(this.showId!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext formContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFieldEditor(
          controller: _nameController,
          label: LocalizationService.instance.getLocalizedString('name'),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: defaultPadding,
              left: formFieldPadding,
              right: formFieldPadding),
          child: Text(
            LocalizationService.instance.getLocalizedString("when"),
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle1!,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: defaultPadding,
              bottom: defaultPadding,
              left: formFieldPadding,
              right: formFieldPadding),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: Padding(
                  padding: EdgeInsets.only(right: defaultPadding),
                  child: Icon(Icons.calendar_today, color: Colors.white)),
              onPressed: () {
                DatePicker.showDateTimePicker(formContext,
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(const Duration(days: 365 * 5)),
                    onConfirm: (date) {
                  setState(() {
                    this.whenLabel = LocalizationService.instance
                        .getFullLocalizedDateAndTime(date.toString());
                    this._whenController.text = date.toString();
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.pt);
              },
              style: OutlinedButton.styleFrom(
                  primary: Colors.white70,
                  side: BorderSide(color: Colors.white54)),
              label: Text(
                this.whenLabel,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        TextFieldEditor(
          controller: _payController,
          label: LocalizationService.instance.getLocalizedString('pay'),
        ),
        TextFieldEditor(
          controller: _addressController,
          label: LocalizationService.instance.getLocalizedString('address'),
        ),
        TextFieldEditor(
          controller: _contactController,
          label: LocalizationService.instance.getLocalizedString('contact'),
        ),
        TextAreaEditor(
          controller: this._notesController,
          label: LocalizationService.instance.getLocalizedString('notes'),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: defaultPadding,
              left: formFieldPadding,
              right: formFieldPadding),
          child: Row(
            children: [
              if (this.showId != null)
                Text(
                  LocalizationService.instance.getLocalizedString("setlist"),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle1!,
                ),
              if (this.showId != null)
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  tooltip: 'Manage setlist',
                  onPressed: () {
                    Navigator.push(
                      formContext,
                      MaterialPageRoute(
                        builder: (context) => SecondaryScreen(
                          activeScreen: ManageSetlistScreen(
                              showId: this.showId!,
                              showName: this._nameController.text,
                              showWhen: this._whenController.text),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        if (this.showId != null)
          Padding(
            padding: EdgeInsets.only(
                top: defaultPadding,
                left: formFieldPadding,
                right: formFieldPadding),
            child: FutureBuilder<int>(
                future: numberOfSongs,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  List<Widget> children = [];
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Text(getNumberOfSongsInSetlistLabel(snapshot.data!),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: defaultFontSize,
                              fontStyle: FontStyle.italic,
                              color: Colors.white54)),
                    ];
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  );
                }),
          ),
        if (this.showId != null)
          FutureBuilder<String>(
              future: this.totalDuration,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                List<Widget> children = [];
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  children = <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: defaultPadding,
                          left: formFieldPadding,
                          right: formFieldPadding),
                      child: Text(
                          LocalizationService.instance
                                  .getLocalizedString('total_duration') +
                              ": " +
                              snapshot.data!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: defaultFontSize,
                              fontStyle: FontStyle.italic,
                              color: Colors.white54)),
                    )
                  ];
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                );
              }),
        SaveButton(
          onPressed: this.saveOrUpdateShow,
        ),
        GoBackButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SonglistPlusMobileApp(activeScreen: AllShowsScreen())),
          );
        }),
        if (this.showId != null) DeleteButton(onPressed: this.delete),
      ],
    );
  }

  String getNumberOfSongsInSetlistLabel(int numberOfSongs) {
    if (this.showId == null)
      return LocalizationService.instance.getLocalizedString('no_songs');

    String numberOfSongsLabel;

    if (numberOfSongs == 0) {
      numberOfSongsLabel =
          LocalizationService.instance.getLocalizedString('no_songs');
    } else if (numberOfSongs == 1) {
      numberOfSongsLabel =
          LocalizationService.instance.getLocalizedString('one_song');
    } else {
      numberOfSongsLabel = numberOfSongs.toString() +
          ' ' +
          LocalizationService.instance.getLocalizedString('multiple_songs');
    }

    return numberOfSongsLabel;
  }

  void saveOrUpdateShow() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String nowFormattedDate = formatter.format(now);
    Show show = Show(
        name: this._nameController.text,
        when: this._whenController.text,
        pay: this._payController.text,
        address: this._addressController.text,
        contact: this._contactController.text,
        notes: this._notesController.text,
        created_on: nowFormattedDate);

    //We are updating
    if (this.showId != null) {
      show.id = showId;
    }

    Validation validation = showService.validate(show);

    if (validation.isValid) {
      this.showService.save(show).then((id) => afterSaveOrUpdate(id));
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
    if (this.showId == null) {
      ToastMessage.showToast(LocalizationService.instance
          .getLocalizedString('show_successfully_created'));
    } else {
      ToastMessage.showToast(LocalizationService.instance
          .getLocalizedString('show_successfully_updated'));
    }

    setState(() {
      this.showId = id;
    });
  }

  void delete() {
    this.showService.delete(this.showId!);

    ToastMessage.showToast(LocalizationService.instance
        .getLocalizedString('show_successfully_deleted'));

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SonglistPlusMobileApp(activeScreen: AllShowsScreen())),
    );
  }
}
