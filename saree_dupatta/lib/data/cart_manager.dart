import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartManager {
  static final List<Product> _cartItems = [];

  /// Get unique key based on current Firebase user
  static String _getUserKey() {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'guest';
    return 'cart_$email'; // unique key per user
  }

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getUserKey();
    final storedCart = prefs.getStringList(key) ?? [];

    _cartItems.clear();
    _cartItems.addAll(
      storedCart.map((item) => Product.fromMap(jsonDecode(item))),
    );
  }

  static Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getUserKey();
    final cartJson = _cartItems.map((p) => jsonEncode(p.toMap())).toList();
    await prefs.setStringList(key, cartJson);
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

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getUserKey();
    await prefs.remove(key);
    _cartItems.clear();
  }
}
