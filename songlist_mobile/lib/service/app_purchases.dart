import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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
    loadPurchases();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> loadPurchases() async {
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

  Future<void> buy(PurchasableProduct product) async {
    // omitted
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    // Handle purchases here
  }

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    //Handle error here
  }
}
