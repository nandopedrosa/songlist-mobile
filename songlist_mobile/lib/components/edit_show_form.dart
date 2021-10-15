import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:songlist_mobile/components/delete_button.dart';
import 'package:songlist_mobile/components/go_back_button.dart';
import 'package:songlist_mobile/components/modal_dialog.dart';
import 'package:songlist_mobile/components/save_button.dart';
import 'package:songlist_mobile/components/text_area_editor.dart';
import 'package:songlist_mobile/components/text_field_editor.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/models/show.dart';
import 'package:songlist_mobile/screens/all_shows_screen.dart';
import 'package:songlist_mobile/service/show_service.dart';
import 'package:songlist_mobile/components/toast_message.dart';
import 'package:songlist_mobile/util/validation.dart';

// ignore: must_be_immutable
class EditShowForm extends StatefulWidget {
  int? showId;

  EditShowForm({
    Key? key,
    this.showId,
  }) : super(key: key);

  @override
  _EditShowForm createState() => _EditShowForm(showId);
}

class _EditShowForm extends State<EditShowForm> {
  int? showId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _whenController = TextEditingController();
  final TextEditingController _payController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  late ShowService service;

  _EditShowForm(this.showId);

  @override
  void initState() {
    super.initState();
    this.service = ShowService();
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
        TextFieldEditor(
          controller: _whenController,
          label: LocalizationService.instance.getLocalizedString('when'),
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

    Validation validation = service.validate(show);

    if (validation.isValid) {
      this.service.save(show).then((id) => afterSaveOrUpdate(id));
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
    this.service.delete(this.showId!);

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
