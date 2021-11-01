import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/show/edit_show_form.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import '../../util/constants.dart';

// ignore: must_be_immutable
class EditShowScreen extends StatefulWidget {
  int? showId;

  EditShowScreen({Key? key, this.showId}) : super(key: key);

  @override
  _EditShowScreen createState() => _EditShowScreen(showId);
}

class _EditShowScreen extends State<EditShowScreen> {
  int? showId;

  _EditShowScreen(this.showId);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: LocalizationService.instance.getLocalizedString('show'),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    EditShowForm(
                      showId: showId,
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
}
