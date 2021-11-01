import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/screens/common/help_screen.dart';
import '../../util/constants.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreen createState() => _AboutScreen();
}

class _AboutScreen extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
                title:
                    LocalizationService.instance.getLocalizedString('about')),
            HelpText(
              isHeadline: true,
              textKey: "about_title",
            ),
            HelpText(
              isHeadline: false,
              textKey: "about_txt",
            ),
            HelpText(
              isHeadline: true,
              textKey: "about_me_title",
            ),
            HelpText(
              isHeadline: false,
              textKey: "about_me_txt",
            ),
            HelpText(
              isHeadline: true,
              textKey: "find_me_title",
            ),
            HelpText(
              isHeadline: false,
              textKey: "find_me_email_txt",
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "songlistplus@gmail.com",
                    style: TextStyle(
                        color: primaryColor, fontSize: defaultFontSize),
                  ))
                ],
              ),
            ),
            HelpText(
              isHeadline: false,
              textKey: "find_me_yt_txt",
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "youtube.com/c/FernandoPedrosaLopes",
                    style: TextStyle(
                        color: primaryColor, fontSize: defaultFontSize),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
