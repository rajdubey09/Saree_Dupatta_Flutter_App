import 'package:flutter/material.dart';
import 'package:saree_dupatta/screens/checkout_screen.dart';

class WishlistScreen extends StatelessWidget {
  final List<Map<String, String>> wishlistItems;

  const WishlistScreen({super.key, required this.wishlistItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: wishlistItems.isEmpty
          ? const Center(
              child: Text(
                'No items in your wishlist yet ❤️',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
      : GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: wishlistItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final product = wishlistItems[index];
          return Card(
            color: const Color(0xFFFFF0F0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    product['image']!,
                    height: 155,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 155,
                        width: double.infinity,
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
                
                // Name and Price
                Padding(padding:  const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      Text(
                        product['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product['price']!,
                        style: const TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Buy Now'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
