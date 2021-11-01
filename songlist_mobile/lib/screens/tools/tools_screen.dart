import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/tools/export_database_screen.dart';
import 'package:songlist_mobile/screens/tools/import_database_screen.dart';
import '../../util/constants.dart';

// ignore: must_be_immutable
class ToolsScreen extends StatefulWidget {
  ToolsScreen({Key? key}) : super(key: key);

  @override
  _ToolsScreen createState() => _ToolsScreen();
}

class _ToolsScreen extends State<ToolsScreen> {
  _ToolsScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
                title:
                    LocalizationService.instance.getLocalizedString('tools')),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            LocalizationService.instance
                                .getLocalizedString("export_songs"),
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1!,
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            tooltip: 'Export Songs',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SonglistPlusMobileApp(
                                        activeScreen: ExportDatabaseScreen())),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          Text(
                            LocalizationService.instance
                                .getLocalizedString("import_songs"),
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1!,
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            tooltip: 'Import Songs',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SonglistPlusMobileApp(
                                        activeScreen: ImportDatabaseScreen())),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
