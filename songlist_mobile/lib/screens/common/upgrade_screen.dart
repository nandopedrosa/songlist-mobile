import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/components/common/side_menu.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/screens/common/help_screen.dart';
import 'package:songlist_mobile/service/app_purchases.dart';
import 'package:songlist_mobile/util/responsive.dart';
import '../../util/constants.dart';

class UpgradeScreen extends StatefulWidget {
  @override
  _UpgradeScreen createState() => _UpgradeScreen();
}

class _UpgradeScreen extends State<UpgradeScreen> {
  @override
  Widget build(BuildContext context) {
    var purchases = Provider.of<AppPurchases>(context, listen: false);
    var products = purchases.products;

    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screens
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      Header(
                          title: LocalizationService.instance
                              .getLocalizedString('upgrade')),
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(purchases.products.first.title),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
