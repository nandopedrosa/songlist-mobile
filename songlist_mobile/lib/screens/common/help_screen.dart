import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import '../../util/constants.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreen createState() => _HelpScreen();
}

class _HelpScreen extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
                title: LocalizationService.instance.getLocalizedString('help')),
            HelpText(
              isHeadline: true,
              textKey: "songs_and_setlists",
            ),
            HelpText(
              isHeadline: false,
              textKey: "songs_and_setlists_txt",
            ),
            HelpText(
              isHeadline: true,
              textKey: "lyrics_and_chords",
            ),
            HelpText(
              isHeadline: false,
              textKey: "lyrics_and_chords_txt",
            ),
            HelpText(
              isHeadline: true,
              textKey: "shows_and_performances",
            ),
            HelpText(
              isHeadline: false,
              textKey: "shows_and_performances_txt",
            ),
            HelpText(
              isHeadline: true,
              textKey: "sharing",
            ),
            HelpText(
              isHeadline: false,
              textKey: "sharing_txt",
            ),
            HelpText(
              isHeadline: true,
              textKey: "exporting_and_importing",
            ),
            HelpText(
              isHeadline: false,
              textKey: "exporting_and_importing_txt",
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

  late bool isHeadline; //If true, changes to a bigger font style
  late String textKey; //To fetch from localizations strings

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
