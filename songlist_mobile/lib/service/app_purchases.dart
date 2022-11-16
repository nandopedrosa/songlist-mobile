import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/models/purchasable_product.dart';
import 'package:songlist_mobile/models/store_state.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/util/iap.dart';

class AppPurchases extends ChangeNotifier {
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final iapConnection = IAPConnection.instance;
  StoreState storeState = StoreState.loading;
  List<PurchasableProduct> products = [];

  AppPurchases() {
    final purchaseUpdated = iapConnection.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    loadProducts();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // Load available products
  Future<void> loadProducts() async {
    final available = await iapConnection.isAvailable();
    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }

    const ids = <String>{noSongLimitId};
    final response = await iapConnection.queryProductDetails(ids);
    for (var element in response.notFoundIDs) {
      debugPrint('Purchase $element not found');
    }
    products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList();
    storeState = StoreState.available;
    notifyListeners();
  }

  //Restores previous purchase
  Future<void> restorePurchase() async {
    await iapConnection.restorePurchases();
  }

  // Buys a product (can be consumable or non consumable - we only deal with the latter)
  Future<void> buy(PurchasableProduct product) async {
    final purchaseParam = PurchaseParam(
        productDetails:
            product.productDetails); // Consider passing App Name parameter
    await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // This is called after each purchase
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(_handlePurchase);
    notifyListeners();
  }

  // For each purchase, complete it, and register it locally
  // We are using shared preferences, but it's best to register it in the cloud
  void _handlePurchase(PurchaseDetails purchaseDetails) {
    // Here we handle purchase error, such as Already Owned Product
    if (purchaseDetails.status == PurchaseStatus.error) {
      if (purchaseDetails.error!.message ==
          "BillingResponse.itemAlreadyOwned") {
        _registerPurchaseLocally(noSongLimitId);
        Fluttertoast.showToast(
            msg: LocalizationService.instance
                .getLocalizedString('item_already_owned'),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Color.fromRGBO(216, 150, 20, 0.8),
            textColor: Colors.white,
            fontSize: defaultFontSize);
      }
    }

    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      _registerPurchaseLocally(purchaseDetails.productID);
    }

    if (purchaseDetails.pendingCompletePurchase) {
      iapConnection.completePurchase(purchaseDetails);
    }
  }

  void _registerPurchaseLocally(String productID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(productID, true);
  }

  static Future<bool> checkPurchaseLocally(String productID) async {
    //We check if the user has purchased the Pro version
    final prefs = await SharedPreferences.getInstance();
    final bool isPurchased = prefs.getBool(productID) ?? false;
    return isPurchased;
  }

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    //Handle error here
  }
}
