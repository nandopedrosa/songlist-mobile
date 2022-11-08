import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/screens/common/help_screen.dart';
import '../../util/constants.dart';

class UpgradeScreen extends StatefulWidget {
  @override
  _UpgradeScreen createState() => _UpgradeScreen();
}

class _UpgradeScreen extends State<UpgradeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
                title:
                    LocalizationService.instance.getLocalizedString('upgrade')),
            HelpText(
              isHeadline: true,
              textKey: "upgrade_title",
            ),
            HelpText(
              isHeadline: false,
              textKey: "upgrade_txt",
            ),
            HelpText(
              isHeadline: false,
              textKey: "upgrade_question",
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(LocalizationService.instance
                        .getLocalizedString('upgrade'))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
