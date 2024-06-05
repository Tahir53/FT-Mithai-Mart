import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _items = [];
  bool _isCustomized = false;
  List _customizationOptions = [];

  bool get isCustomized => _isCustomized;
  List<Cart> get items => _items;
  List get customizationOptions => _customizationOptions;

  void updateCustomize(){
    _isCustomized = true;
    notifyListeners();
  }

  void updateCustomizationOptions(List options){
    _customizationOptions = options;
    notifyListeners();
  }

  void addToCart(Cart item) {
    print("add to cart called");
    _items.add(item);
    print("Items in add to cart: $_items");
    notifyListeners();
  }

  void removeFromCart(Cart item) {
    print("remove from cart called");
    _items.remove(item);
    print("items in remove to cart: $_items");
    notifyListeners();
  }

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartData = _items.map((item) => item.toString()).toList();
    prefs.setString('cart', jsonEncode(cartData));
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

  clearCart(){
    _items.clear();
    notifyListeners();
  }
}
