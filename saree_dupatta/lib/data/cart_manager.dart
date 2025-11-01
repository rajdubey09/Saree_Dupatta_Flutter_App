import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class CartManager {
  static final List<Product> _cartItems = [];

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final storedCart = prefs.getStringList('cart') ?? [];
    _cartItems.clear();
   _cartItems.addAll(storedCart.map((item) => Product.fromMap(jsonDecode(item))));
  }

  static Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _cartItems.map((p) => jsonEncode(p.toMap())).toList();
    await prefs.setStringList('cart', cartJson);
  }

  static List<Product> get cartItems => _cartItems;

  static bool isInCart(Product product) {
    return _cartItems.any((item) => item.name == product.name);
  }

  static Future<void> addToCart(Product product) async {
    if (!isInCart(product)) {
      _cartItems.add(product);
      await _saveToPrefs();
    }
  }

  static Future<void> removeFromCart(Product product) async {
    _cartItems.removeWhere((item) => item.name == product.name);
    await _saveToPrefs();
  }
}
