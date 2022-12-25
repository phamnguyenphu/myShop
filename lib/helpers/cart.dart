import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> addProductToCart(
    String id, Map<String, dynamic> data, int quantity) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List productsList = [];
    bool isAdd = true;

    dynamic productToSave = {
      "id": id,
      "productName": data["productName"],
      "productImage": data["productImage"],
      "price": data["price"],
      "salePrice": data["salePrice"],
      "quantity": quantity,
    };

    // get exsisting products
    String products = prefs.getString("cart") ?? '';

    // add new product
    if (products != '' && products.isNotEmpty) {
      productsList = json.decode(products);
    }
    for (var item in productsList) {
      if (item['id'] == productToSave['id']) {
        item["quantity"]++;
        isAdd = false;
      }
    }

    if (isAdd == true) {
      productsList.add(productToSave);
    }

    // save
    String cart = json.encode(productsList);

    await prefs.setString("cart", cart);
    return isAdd;
  } catch (e) {
    return false;
    debugPrint(e.toString());
  }
}

Future<dynamic> getCart() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic productsList = [];

    // get exsisting products
    String products = prefs.getString("cart") ?? '';

    if (products == '') {
      return null;
    } else {
      productsList = json.decode(products);
      return productsList;
    }
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}

Future<void> deleteProductFromCart(index) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List productsList = [];

    // get exsisting products
    String products = prefs.getString("cart") ?? '';

    productsList = json.decode(products);

    productsList.removeAt(index);
    // save
    String cart = json.encode(productsList);

    await prefs.setString("cart", cart);
  } catch (e) {
    debugPrint(e.toString());
    return;
  }
}

Future<void> clearCart() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("cart");
  } catch (e) {
    debugPrint(e.toString());
  }
}
