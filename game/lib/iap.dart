import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class IAP {
  static Future<IAPItem> getSupportProduct() async {
    try {
      final products = await FlutterInappPurchase.getProducts(
          Platform.isAndroid ? ['support_coffee'] : ['1475026492' ]//xyz.fireslime.bob_box.support_coffee
      );

      return products.first;
    } catch (e) {
      print("Error getting product");
      print("$e");

      throw e;
    }
  }

  static Future<bool> hasAlreadyBought() async {
    try {
      final products = await FlutterInappPurchase.getPurchaseHistory();
      return products != null && products.length > 0;
    } catch (e) {
      print("Error fetching iap purchase");
      print("$e");

      return false;
    }
  }

  static Future<void> initConnection() async {
    await FlutterInappPurchase.initConnection;
  }

  static Future<void> endConnection() async {
    await FlutterInappPurchase.endConnection;
  }
}
