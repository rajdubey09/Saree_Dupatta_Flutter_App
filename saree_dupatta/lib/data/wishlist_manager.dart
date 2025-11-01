import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistManager {
  static final List<Map<String, String>> _wishlist = [];

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedWishlist = prefs.getString('wishlist');
    if (savedWishlist != null) {
      final List decoded = jsonDecode(savedWishlist);
      _wishlist.clear();
      _wishlist.addAll(decoded.map((e) => Map<String, String>.from(e)));
    }
  }

  // Get all wishlist items
  static List<Map<String, String>> getWishlist() {
    return _wishlist;
  }

  // Check if item exists in wishlist
  static bool isInWishlist(Map<String, String> product) {
    return _wishlist.any((item) => item['name'] == product['name']);
  }

  // Add item to wishlist
  static Future<void> addItem(Map<String, String> product) async {
    if (!isInWishlist(product)) {
      _wishlist.add(product);
      await _saveToLocal();
    }
  }

  static Future<void> removeItem(Map<String, String> product) async {
    _wishlist.removeWhere((item) => item['name'] == product['name']);
    await _saveToLocal();
  }

  static Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wishlist', jsonEncode(_wishlist));
  }
}