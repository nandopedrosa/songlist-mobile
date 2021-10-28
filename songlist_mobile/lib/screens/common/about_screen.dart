import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
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

// ignore: must_be_immutable
class HelpText extends StatelessWidget {
  HelpText({Key? key, required isHeadline, required textKey})
      : this.isHeadline = isHeadline,
        this.textKey = textKey,
        super(key: key);

  late bool isHeadline;
  late String textKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          if (isHeadline)
            Expanded(
              child: Text(
                LocalizationService.instance.getLocalizedString(textKey),
                style: Theme.of(context).textTheme.headline6,
              ),
            )
          else
            Expanded(
              child: Text(
                LocalizationService.instance.getLocalizedString(textKey),
                style:
                    TextStyle(fontSize: defaultFontSize, color: Colors.white54),
              ),
            )
        ],
      ),
    );
  }
}
