import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import "package:shared_preferences/shared_preferences.dart";

class IAP {
  static Future<IAPItem> getSupportProduct() async {
    try {
      final products = await FlutterInappPurchase.getProducts(
          Platform.isAndroid ? ['support_coffee'] : ['xyz.fireslime.bob_box.support_coffee']
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool cache = prefs.getBool("purchaseCache");

      if (cache != null) {
        return cache;
      }

      final products = await FlutterInappPurchase.getPurchaseHistory();
      bool hasBought = products != null && products.length > 0;

      prefs.setBool("purchaseCache", hasBought);

      return hasBought;
    } catch (e) {
      print("Error fetching iap purchase");
      print("$e");

      return false;
    }
  }

  static Future<void> buy(String productId) async {
    await FlutterInappPurchase.buyProduct(productId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("purchaseCache", true);
  }

  static Future<void> initConnection() async {
    try {
      print("Initing iap connection");
      await FlutterInappPurchase.initConnection;
      print("Iap connection done");
    } catch (e) {
      print("Error initing iap connection");
      print("$e");
    }
  }

  static Future<void> endConnection() async {
    await FlutterInappPurchase.endConnection;
  }
}
