import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/export_button.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/components/common/import_button.dart';
import 'package:songlist_mobile/localization/localization_service.dart';

import '../../util/constants.dart';

// ignore: must_be_immutable
class ImportDatabaseScreen extends StatefulWidget {
  ImportDatabaseScreen({Key? key}) : super(key: key);

  @override
  _ImportDatabaseScreen createState() => _ImportDatabaseScreen();
}

class _ImportDatabaseScreen extends State<ImportDatabaseScreen> {
  _ImportDatabaseScreen();

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
                        ImportButton(onPressed: () {
                          this._import();
                        })
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

  void _import() {}
}
