import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/export_button.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';

import '../../util/constants.dart';

// ignore: must_be_immutable
class ExportDatabaseScreen extends StatefulWidget {
  ExportDatabaseScreen({Key? key}) : super(key: key);

  @override
  _ExportDatabaseScreen createState() => _ExportDatabaseScreen();
}

class _ExportDatabaseScreen extends State<ExportDatabaseScreen> {
  _ExportDatabaseScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
                title: LocalizationService.instance
                    .getLocalizedString('export_songs')),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              LocalizationService.instance.getLocalizedString(
                                  "export_database_disclaimer"),
                              style: Theme.of(context).textTheme.subtitle1!,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ExportButton(onPressed: () {
                            this._export();
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

  void _export() {}
}
