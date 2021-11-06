import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/back_header.dart';
import 'package:songlist_mobile/components/show/edit_show_form.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/show/all_shows_screen.dart';
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
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    BackHeader(
                        title: LocalizationService.instance
                            .getLocalizedString("show"),
                        goBack: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SonglistPlusMobileApp(
                                  activeScreen: AllShowsScreen()),
                            ),
                          );
                        }),
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
