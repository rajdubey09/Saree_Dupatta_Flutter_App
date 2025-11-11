import 'package:flutter/material.dart';
import 'package:saree_dupatta/screens/checkout_screen.dart';
import 'package:saree_dupatta/data/cart_manager.dart';
import 'package:saree_dupatta/data/wishlist_manager.dart';
import 'package:saree_dupatta/models/product_model.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, String>> wishlistItems = [];
  Set<String> cartProductNames = {};

  @override
  void initState() {
    super.initState();
    _loadWishlist();
    _loadCartItems();
  }

  Future<void> _loadWishlist() async {
    await WishlistManager.initialize();
    setState(() {
      wishlistItems = List<Map<String, String>>.from(WishlistManager.wishlistItems);
    });
  }

  Future<void> _loadCartItems() async {
    await CartManager.initialize();
    setState(() {
      cartProductNames = CartManager.cartItems.map((e) => e.name).toSet();
    });
  }

  Future<void> _addToCart(Map<String, String> product) async {
    final newProduct = Product(
      name: product['name'] ?? '',
      price: double.tryParse(product['price']?.replaceAll('₹', '') ?? '') ?? 0.0,
      imageUrl: product['image'] ?? '',
    );

    await CartManager.addToCart(newProduct);
    setState(() {
      cartProductNames.add(newProduct.name);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart!'), duration: Duration(seconds: 1)),
    );
  }

  Future<void> _removeFromWishlist(Map<String, String> product) async {
    await WishlistManager.removeItem(product);
    setState(() {
      wishlistItems.removeWhere((item) => item['name'] == product['name']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from wishlist'), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: wishlistItems.isEmpty
          ? const Center(
              child: Text(
                'No items in your wishlist yet ❤️',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 5),
              child: Column(
                children: wishlistItems.map((product) {
                  final alreadyInCart = cartProductNames.contains(product['name']);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: const Color.fromARGB(255, 248, 247, 247),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              product['image']!,
                              height: 120,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 120,
                                  width: 100,
                                  color: Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  product['price']!,
                                  style: const TextStyle(
                                    color: Colors.pinkAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    if (!alreadyInCart)
                                      IconButton(
                                        onPressed: () => _addToCart(product),
                                        icon: const Icon(Icons.shopping_cart),
                                        color: Colors.red,
                                        iconSize: 26,
                                        tooltip: 'Add to Cart',
                                      ),
                                    // const SizedBox(width: 1),
                                    IconButton(
                                      onPressed: () {
                                        final singleItem = [
                                          {
                                            'name': product['name'],
                                            'price': product['price'],
                                            'quantity': 1,
                                            'image': product['image'],
                                          }
                                        ];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CheckoutScreen(
                                              cartItems: singleItem,
                                              totalAmount: product['price'] != null
                                                  ? double.tryParse(product['price']!.replaceAll('₹', '')) ?? 0.0
                                                  : 0.0,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.payment),
                                      color: Colors.pinkAccent,
                                      iconSize: 26,
                                      tooltip: 'Buy Now',
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => _removeFromWishlist(product),
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}