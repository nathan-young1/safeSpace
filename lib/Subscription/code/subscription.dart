import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';

const playStoreId = 'premium_plan';
StreamController updateState = StreamController();
// ignore: must_be_immutable
class SafeSpaceSubscription{
  //Enable plugin
  static final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  //products for sale
  static List<ProductDetails> _products = [];
  //past purchases
  static List<PurchaseDetails> _purchases = [];
  //updates to purchase
  static StreamSubscription _subscription;

  static initalizePlugin() async {
    bool pluginAvailable = await _iap.isAvailable();

      if (pluginAvailable){
        await Future.wait([_getProducts(),_getPastPurchases()]);
        print(_purchases);
        _subscription = _iap.purchaseUpdatedStream.listen((data) async {
          
          data.forEach((e)=> print('$e just entered'));
          await Future.wait([_verifyPurchase(),_getPastPurchases()]);
          updateState.add(null);
        },
        onDone: ()=> _subscription.cancel(),
        onError: (e)=> print(e)
        );
      }
  }


  static PurchaseDetails _hasPurchased(){
  return _purchases.firstWhere((purchase) => purchase.productID == playStoreId, orElse: ()=> null);
  }

  static void buyProduct(){
  ProductDetails product =_products.firstWhere((product) => product.id == playStoreId,orElse: ()=> null);
  if(product != null){
  final PurchaseParam purchaseParam = PurchaseParam(productDetails: product,applicationUserName: email);
  _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }
  }


  static Future<void> _getProducts() async {
  Set<String> id = {playStoreId};
  ProductDetailsResponse response = await _iap.queryProductDetails(id);
  _products.addAll(response.productDetails);
  }


  static Future _verifyPurchase() async {
  PurchaseDetails purchase = _hasPurchased();

  if (purchase != null && purchase.status == PurchaseStatus.purchased){
    print('purchase ${purchase.verificationData.localVerificationData}');
    await _iap.completePurchase(purchase);
  }else if(purchase != null && purchase.status == PurchaseStatus.pending){
    await _iap.completePurchase(purchase);
  }
  }

  static bool get isPremiumUser => (_hasPurchased() != null) ? true : false;
  

  static Future<void> _getPastPurchases() async { 
  QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases(applicationUserName: email);
  for (PurchaseDetails purchase in response.pastPurchases) {
      final pending = Platform.isIOS
        ? purchase.pendingCompletePurchase
        : !purchase.billingClientPurchase.isAcknowledged;
      if(pending){
         await _iap.completePurchase(purchase);
      }
    }
    if(response.error != null){
      print('the errors are ${response.error}');
    }
    _purchases = response.pastPurchases;
  }
  
  static timeLeftToExpire(){
    PurchaseDetails purchase = _hasPurchased();
    if(purchase != null){
    var expirationTime = DateTime.fromMillisecondsSinceEpoch(int.parse(purchase.transactionDate)).add(Duration(minutes: 33));
    var timeDifference = expirationTime.difference(DateTime.now());
    if(timeDifference.inMinutes.isNegative){
    _getPastPurchases().then((_){});
      var time = 33 - (timeDifference.inMinutes.abs() % 33);
      return time;
    }else{
      return timeDifference.inMinutes;
    }
    }
  }
  }