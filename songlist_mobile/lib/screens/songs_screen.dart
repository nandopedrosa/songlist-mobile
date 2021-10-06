import 'package:songlist_mobile/components/header.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class SongsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: "Songs"),
            SizedBox(height: defaultPadding),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    //RecentShowsGrid(),
                    SizedBox(height: defaultPadding),
                    //RecentFiles(),
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
