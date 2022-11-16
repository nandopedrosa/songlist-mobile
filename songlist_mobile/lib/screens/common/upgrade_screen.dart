import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/components/common/side_menu.dart';
import 'package:songlist_mobile/controllers/MenuController.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/models/purchasable_product.dart';
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
    AppPurchases purchases = context.watch<AppPurchases>();
    List<PurchasableProduct> listOfProducts = purchases.products;
    PurchasableProduct noSongLimitProduct =
        listOfProducts.firstWhere((p) => p.id == noSongLimitId);

    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(defaultPadding),
                  child: FutureBuilder<bool>(
                      future: AppPurchases.checkPurchaseLocally(noSongLimitId),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          bool isProVersion = snapshot.data!;
                          if (isProVersion) {
                            return Column(
                              children: [
                                Header(
                                  title: LocalizationService.instance
                                      .getLocalizedString('upgrade'),
                                ),
                                HelpText(
                                  isHeadline: false,
                                  textKey: "already_upgraded",
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Header(
                                  title: LocalizationService.instance
                                      .getLocalizedString('upgrade'),
                                ),
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
                                        onPressed: () {
                                          purchases
                                              .buy(noSongLimitProduct)
                                              .then((_) {
                                            setState(() {});
                                          });
                                        },
                                        child: Text(LocalizationService.instance
                                            .getLocalizedString('upgrade'))),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                HelpText(
                                  isHeadline: false,
                                  textKey: "restore_purchase_text",
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey),
                                        onPressed: () {
                                          purchases.restorePurchase().then((_) {
                                            setState(() {});
                                          });
                                        },
                                        child: Text(LocalizationService.instance
                                            .getLocalizedString(
                                                'restore_purchase'))),
                                  ),
                                ),
                              ],
                            );
                          }
                        } else {
                          return Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          );
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
