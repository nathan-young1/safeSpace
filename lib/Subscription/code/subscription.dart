import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';

const playStoreId = 'premium_plan';
StreamController updateState = StreamController();
// ignore: must_be_immutable
class SafeSpaceSubscription{
  //Enable plugin
  static final InAppPurchase _iap = InAppPurchase.instance;
  //products for sale
  static List<ProductDetails> _products = [];
  //past purchases
  static List<PurchaseDetails> _purchases = [];
  //updates to purchase
  static StreamSubscription? _subscription;

  static initalizePlugin() async {
    bool pluginAvailable = await _iap.isAvailable();
      if (pluginAvailable){

        _subscription = _iap.purchaseStream.listen((purchase) async {
          
          debugPrint('$purchase here now');
          purchase.forEach((element) {print(element.verificationData.localVerificationData);});
          await _getPastPurchases(purchase);
          await _completePurchase();
          updateState.add(null);
        },
        onDone: ()=> _subscription!.cancel(),
        onError: (e)=> print(e)
        );

        await _getProducts();
        await _iap.restorePurchases();

      }
  }


  static PurchaseDetails? _hasPurchased(){
    if(_purchases.isNotEmpty)
    return _purchases.firstWhere((purchase) => purchase.productID == playStoreId);
    else
    return null;
  }

  static Future<void> buyProduct() async {
     ProductDetails? product = _products.firstWhere((product) => product.id == playStoreId);

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }


  static Future<void> _getProducts() async {
    ProductDetailsResponse response = await _iap.queryProductDetails({playStoreId});
    _products.addAll(response.productDetails);
  }


  static Future _completePurchase() async {
  PurchaseDetails purchase = _hasPurchased()!;

  if (purchase != null && purchase.status == PurchaseStatus.purchased){
      await _iap.completePurchase(purchase);
      print('purchase ${purchase.verificationData.localVerificationData}');
    }else if(purchase != null && purchase.status == PurchaseStatus.pending){
      await _iap.completePurchase(purchase);
    }else if (purchase != null && purchase.status == PurchaseStatus.restored){
      await _iap.completePurchase(purchase);
  }

  }

  static bool get isPremiumUser => (_hasPurchased() != null) ? true : false;
  

  static Future<void> _getPastPurchases(List<PurchaseDetails> purchaseDetailsList) async {
 
    for (PurchaseDetails purchase in purchaseDetailsList) {
      final pending = purchase.pendingCompletePurchase;
      if(pending){
         await _iap.completePurchase(purchase);
      }

      if(purchase.error != null){
        print('the errors are ${purchase.error}');
      }else _purchases.add(purchase);

    }

  }
  
  static timeLeftToExpire(){
    PurchaseDetails purchase = _hasPurchased()!;
    var expirationTime = DateTime.fromMillisecondsSinceEpoch(int.parse(purchase.transactionDate!)).add(Duration(days: 366));
    var timeDifference = expirationTime.difference(DateTime.now());
    if(timeDifference.inDays.isNegative){
      var time = 366 - (timeDifference.inDays.abs() % 366);
      return time;
    }else{
      return timeDifference.inDays;
    }
  }
  }