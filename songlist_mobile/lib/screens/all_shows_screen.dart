import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/all_shows_table.dart';
import 'package:songlist_mobile/components/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/edit_show_screen.dart';
import 'package:songlist_mobile/util/responsive.dart';
import '../util/constants.dart';

// ignore: must_be_immutable
class AllShowsScreen extends StatefulWidget {
  @override
  _AllShowsScreenState createState() => _AllShowsScreenState();
}

class _AllShowsScreenState extends State<AllShowsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
                title:
                    LocalizationService.instance.getLocalizedString('shows')),
            SizedBox(height: defaultPadding),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding /
                                  (Responsive.isMobile(context) ? 2 : 1),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SonglistPlusMobileApp(
                                  activeScreen: EditShowScreen(),
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.add),
                          label: Text(
                            LocalizationService.instance
                                .getLocalizedString('new_show'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultPadding),
                    AllShowsTable(),
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
