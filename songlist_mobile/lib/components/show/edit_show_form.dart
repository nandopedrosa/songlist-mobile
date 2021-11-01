import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:songlist_mobile/components/common/delete_button.dart';
import 'package:songlist_mobile/components/common/go_back_button.dart';
import 'package:songlist_mobile/components/common/modal_dialog.dart';
import 'package:songlist_mobile/components/common/save_button.dart';
import 'package:songlist_mobile/components/common/text_area_editor.dart';
import 'package:songlist_mobile/components/common/text_field_editor.dart';
import 'package:songlist_mobile/components/common/text_form_field_disabled.dart';
import 'package:songlist_mobile/components/common/toast_message.dart';
import 'package:songlist_mobile/components/show/play_button.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/models/show.dart';
import 'package:songlist_mobile/screens/common/secondary_screen.dart';
import 'package:songlist_mobile/screens/show/all_shows_screen.dart';
import 'package:songlist_mobile/screens/show/manage_setlist_screen.dart';
import 'package:songlist_mobile/screens/show/perform_screen.dart';
import 'package:songlist_mobile/service/setlist_service.dart';
import 'package:songlist_mobile/service/show_service.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/util/validation.dart';

// ignore: must_be_immutable
class EditShowForm extends StatefulWidget {
  int? showId;

  EditShowForm({Key? key, this.showId}) : super(key: key);

  @override
  _EditShowForm createState() => _EditShowForm(showId);
}

class _EditShowForm extends State<EditShowForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _whenController = TextEditingController();
  //Trick to update controller asynchonously
  final TextEditingController _whenLabelController = TextEditingController();
  final TextEditingController _payController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _numberOfSongsController =
      TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  int? showId;
  late ShowService showService;
  late SetlistService setListService;

  _EditShowForm(int? showId) {
    this.showId = showId;
  }

  //Update the controller values when we fetch the model
  void _updateControllers(Show show) {
    this._nameController.text = show.name;
    if (show.when != null) {
      this._whenController.text = show.when!;
      this._whenLabelController.text =
          LocalizationService.instance.getFullLocalizedDateAndTime(show.when!);
    }
    if (show.pay != null) this._payController.text = show.pay!;
    if (show.address != null) this._addressController.text = show.address!;
    if (show.contact != null) this._contactController.text = show.contact!;
    if (show.notes != null) this._notesController.text = show.notes!;
    this._durationController.text =
        LocalizationService.instance.getLocalizedString("duration") +
            ": " +
            show.duration;
    this._numberOfSongsController.text =
        getPrettyNumberOfSongs(show.numberOfSongs);
  }

  @override
  void initState() {
    super.initState();
    this.showService = ShowService();
    this.setListService = SetlistService();

    if (this.showId != null) {
      // Pre existing show
      showService.find(showId!).then((show) {
        this._updateControllers(show);
      });
    } else {
      //New show
      this._whenLabelController.text =
          LocalizationService.instance.getLocalizedString("select_date");
      this._durationController.text =
          LocalizationService.instance.getLocalizedString("duration") +
              ": 00:00";
      this._numberOfSongsController.text =
          LocalizationService.instance.getLocalizedString('no_songs');
    }
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
                this._showDatePicker(formContext);
              },
              style: OutlinedButton.styleFrom(
                  primary: Colors.white70,
                  side: BorderSide(color: Colors.white54)),
              label: TextFormFieldDisabled(
                alignment: TextAlign.start,
                controller: _whenLabelController,
                fontSize: defaultFontSize,
                color: Colors.white70,
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
                          ),
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
              top: formFieldPadding,
              left: formFieldPadding,
              right: formFieldPadding,
            ),
            child: TextFormFieldDisabled(
              alignment: TextAlign.start,
              controller: _numberOfSongsController,
              fontSize: defaultFontSize,
              color: Colors.white54,
              fontStyle: FontStyle.italic,
            ),
          ),
        if (this.showId != null)
          Padding(
            padding: EdgeInsets.only(
                top: 0, left: formFieldPadding, right: formFieldPadding),
            child: TextFormFieldDisabled(
              alignment: TextAlign.start,
              controller: _durationController,
              fontSize: defaultFontSize,
              color: Colors.white54,
              fontStyle: FontStyle.italic,
            ),
          ),
        SaveButton(
          onPressed: this.saveOrUpdateShow,
        ),
        if (this.showId != null)
          PlayButton(onPressed: () {
            this.setListService.getNumberOfSongs(this.showId!).then((value) {
              if (value > 0) {
                Navigator.push(
                  formContext,
                  MaterialPageRoute(
                    builder: (context) => SecondaryScreen(
                      activeScreen: PerformScreen(
                          showId: this.showId!,
                          showName: this._nameController.text),
                    ),
                  ),
                );
              } else {
                ToastMessage.showErrorToast(LocalizationService.instance
                    .getLocalizedString('no_songs'));
              }
            });
          }),
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

  // Returns the number of songs in a pretty format
  String getPrettyNumberOfSongs(int numberOfSongs) {
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

  // Shows then "When" date picker
  void _showDatePicker(BuildContext context) {
    DatePicker.showDateTimePicker(context,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(const Duration(days: 365 * 5)),
        onConfirm: (date) {
      setState(() {
        this._whenLabelController.text = LocalizationService.instance
            .getFullLocalizedDateAndTime(date.toString());
        this._whenController.text = date.toString();
      });
    },
        currentTime: DateTime.now(),
        locale: LocalizationService.instance.getPreferredLanguage() == 'en'
            ? LocaleType.en
            : LocaleType.pt);
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
      ToastMessage.showSuccessToast(LocalizationService.instance
          .getLocalizedString('show_successfully_created'));
    } else {
      ToastMessage.showSuccessToast(LocalizationService.instance
          .getLocalizedString('show_successfully_updated'));
    }

    setState(() {
      this.showId = id;
    });
  }

  void delete() {
    this.showService.delete(this.showId!);

    ToastMessage.showSuccessToast(LocalizationService.instance
        .getLocalizedString('show_successfully_deleted'));

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SonglistPlusMobileApp(activeScreen: AllShowsScreen())),
    );
  }
}
