import 'package:flutter/material.dart';

import 'package:songlist_mobile/components/header.dart';
import 'package:songlist_mobile/components/recent_shows_grid.dart';
import 'package:songlist_mobile/components/recent_songs_table.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/responsive.dart';

import '../../constants.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: "Home"),
            SizedBox(height: defaultPadding),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    RecentShowsGrid(),
                    SizedBox(height: defaultPadding * 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Recently Added Songs",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1!),
                        ElevatedButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding /
                                  (Responsive.isMobile(context) ? 2 : 1),
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(Icons.add),
                          label: Text("Change Me"),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultPadding),
                    RecentSongsTable(),
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
