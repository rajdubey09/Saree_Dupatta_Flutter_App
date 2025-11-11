import 'package:flutter/material.dart';
import 'package:saree_dupatta/screens/checkout_screen.dart';
import '../data/cart_manager.dart';
import '../../models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> cartItems = [];
  Map<Product, int> quantities = {};
  Map<Product, TextEditingController> quantityControllers = {};

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    await CartManager.initialize(); // refresh from shared prefs
    setState(() {
      cartItems = List<Product>.from(CartManager.cartItems);
      for (var item in cartItems) {
        quantities[item] = quantities[item] ?? 1;
        quantityControllers[item] = TextEditingController(text: quantities[item].toString());
      }
    });
  }

  void _removeItem(Product product) async {
    await CartManager.removeFromCart(product);
    _loadCart();
  }

  // void _incrementQuantity(Product product) async {
  //   // For now, quantity tracking not stored in model, so we just notify user.
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Quantity update feature coming soon')),
  //   );
  // }

  // void _decrementQuantity(Product product) async {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Quantity update feature coming soon')),
  //   );
  // }

  double get totalAmount {
    double total = 0;
    for (var item in cartItems) {
      final qty = quantities[item] ?? 1;
      total += item.price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty 🛒',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 🖼 Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item.imageUrl,
                                width: 100,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[200],
                                  width: 100,
                                  height: 120,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // 📄 Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${item.price}',
                                    style: const TextStyle(
                                      color: Colors.pinkAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // ➕➖ Quantity Row (static for now)
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 250, 250, 250),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text("  Quantity:", style: TextStyle(fontWeight: FontWeight.w500)),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              width: 70,
                                              child: TextField(
                                                controller: quantityControllers[item],
                                                keyboardType: TextInputType.number,
                                                maxLength: 5,
                                                decoration: InputDecoration(
                                                counterText: "", // hides character counter
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                                ),
                                                onChanged: (value) {
                                                  final qty = int.tryParse(value) ?? 1;
                                                  setState(() {
                                                    quantities[item] = qty;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  // 🗑 Remove Button
                                  GestureDetector(
                                    onTap: () => _removeItem(item),
                                    child: const Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w500,
                                        // decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // 💰 Total + Checkout
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, -2))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Amount',
                              style: TextStyle(color: Colors.grey)),
                          Text(
                            '₹${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: cartItems.isEmpty
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                      cartItems: cartItems
                                          .map((e) => {
                                                'name': e.name,
                                                'price': e.price,
                                                'image': e.imageUrl,
                                                'quantity': quantities[e] ?? 1,
                                              })
                                          .toList(),
                                      totalAmount: totalAmount,
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
