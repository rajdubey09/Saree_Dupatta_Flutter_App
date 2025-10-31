class WishlistManager {
  static final List<Map<String, String>> _wishlistItems = [];

  // Add item to wishlist
  static void addItem(Map<String, String> product) {
    // prevent duplicate entries
    if (!_wishlistItems.any((item) => item['name'] == product['name'])) {
      _wishlistItems.add(product);
    }
  }

  // Remove item from wishlist
  static void removeItem(Map<String, String> product) {
    _wishlistItems.removeWhere((item) => item['name'] == product['name']);
  }

  // Get all wishlist items
  static List<Map<String, String>> getWishlist() {
    return List.from(_wishlistItems);
  }

  // Check if item exists in wishlist
  static bool isInWishlist(Map<String, String> product) {
    return _wishlistItems.any((item) => item['name'] == product['name']);
  }
}
