import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/model/cart_model.dart';
import 'package:ftmithaimart/model/order_design_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _items = [];
  bool _isCustomized = false;
  List<OrderDesignModel> _customizationOptions = [];

  bool get isCustomized => _isCustomized;

  List<Cart> get items => _items;

  List<OrderDesignModel> get customizationOptions => _customizationOptions;

  void updateCustomize(bool isCustomized) {
    _isCustomized = isCustomized;
    notifyListeners();
  }

  void resetCustomize() {
    _isCustomized = false;
    notifyListeners();
  }

  void updateCustomizationOptions(List options) {
    _customizationOptions =
        options.map((option) => OrderDesignModel.fromJson(option)).toList();
    notifyListeners();
  }

  void addToCart(Cart item) {
    _items.add(item);
    notifyListeners();
  }

  void removeFromCart(Cart item) {
    _items.remove(item);
    notifyListeners();
  }

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');

    if (cartData != null) {
      var temp = jsonDecode(cartData);
      _items = temp.map<Cart>((item) => Cart.fromJson(item)).toList();
    }

    notifyListeners();
  }

  clearCart() {
    _items.clear();
    notifyListeners();
  }
}
