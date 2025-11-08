import 'package:flutter/material.dart';
import 'package:saree_dupatta/screens/checkout_screen.dart';

class WishlistScreen extends StatelessWidget {
  final List<Map<String, String>> wishlistItems;

  const WishlistScreen({super.key, required this.wishlistItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5), // light background like cart screen
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: wishlistItems.isEmpty
          ? const Center(
              child: Text(
                'No items in your wishlist yet ❤️',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12), // tighter padding
              child: Column(
                children: wishlistItems.map((product) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: const Color(0xFFFFEDEE), // soft pink card
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
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 90,
                                  width: 90,
                                  color: Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image,
                                      size: 40, color: Colors.grey),
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
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
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    // 🛒 Add to Cart Icon
                                    IconButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Added to cart!'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.shopping_cart),
                                      color: Colors.red,
                                      iconSize: 26,
                                      tooltip: 'Add to Cart',
                                    ),

                                    const SizedBox(width: 8),

                                    // 💳 Buy Now Icon
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
                                                  ? double.tryParse(product['price']!
                                                          .replaceAll('₹', '')) ??
                                                      0.0
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