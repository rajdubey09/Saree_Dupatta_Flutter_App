import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistManager {
  static final List<Map<String, String>> _wishlist = [];

  /// 🔹 Load wishlist from SharedPreferences (user-specific)
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    final userKey = user != null ? 'wishlist_${user.uid}' : 'wishlist_guest';

    final storedWishlist = prefs.getStringList(userKey) ?? [];
    _wishlist.clear();
    _wishlist.addAll(
      storedWishlist.map((item) => Map<String, String>.from(jsonDecode(item))),
    );
  }

  /// 🔹 Save wishlist to SharedPreferences
  static Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    final userKey = user != null ? 'wishlist_${user.uid}' : 'wishlist_guest';

    final wishlistJson = _wishlist.map((p) => jsonEncode(p)).toList();
    await prefs.setStringList(userKey, wishlistJson);
  }

  /// 🔹 Get all wishlist items
  static List<Map<String, String>> get wishlistItems => _wishlist;

  /// 🔹 Check if a product is in wishlist
  static bool isInWishlist(Map<String, String> product) {
    return _wishlist.any((item) => item['name'] == product['name']);
  }

  /// 🔹 Add product to wishlist
  static Future<void> addItem(Map<String, String> product) async {
    if (!isInWishlist(product)) {
      _wishlist.add(product);
      await _saveToPrefs();
    }
  }

  /// 🔹 Remove product from wishlist
  static Future<void> removeItem(Map<String, String> product) async {
    _wishlist.removeWhere((item) => item['name'] == product['name']);
    await _saveToPrefs();
  }

  /// 🔹 Clear wishlist (on logout)
  static Future<void> clearWishlist() async {
    _wishlist.clear();
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    final userKey = user != null ? 'wishlist_${user.uid}' : 'wishlist_guest';
    await prefs.remove(userKey);
  }
}
