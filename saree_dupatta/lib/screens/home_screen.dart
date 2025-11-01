import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:saree_dupatta/screens/checkout_screen.dart';
import 'package:saree_dupatta/data/wishlist_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WishlistManager wishlistManager = WishlistManager();

  final List<String> bannerImages = [
    'assets/images/saree1.png',
    'assets/images/saree2.jpg',
    'assets/images/saree3.jpg',
    'assets/images/saree4.png',
  ];

  final List<Map<String, String>> products = [
    {'name': 'Banarasi Silk Saree', 'price': '₹1299', 'image': 'assets/images/saree1.png'},
    {'name': 'Cotton Printed Saree', 'price': '₹799', 'image': 'assets/images/saree2.jpg'},
    {'name': 'Designer Dupatta', 'price': '₹499', 'image': 'assets/images/saree3.jpg'},
    {'name': 'Wedding Saree', 'price': '₹1999', 'image': 'assets/images/saree4.png'},
    {'name': 'Banarasi Silk Saree', 'price': '₹1299', 'image': 'assets/images/saree1.png'},
    {'name': 'Cotton Printed Saree', 'price': '₹799', 'image': 'assets/images/saree2.jpg'},
    {'name': 'Designer Dupatta', 'price': '₹499', 'image': 'assets/images/saree3.jpg'},
    {'name': 'Wedding Saree', 'price': '₹1999', 'image': 'assets/images/saree4.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saree & Dupatta Shop'),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 3),

            // 🔹 Banner Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 160,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
              items: bannerImages.map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(url, fit: BoxFit.cover, width: double.infinity),
                );
              }).toList(),
            ),

            // 🔹 Product Grid
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isWishlisted = WishlistManager.isInWishlist(product);

                  return Card(
                    color: const Color(0xFFFFF0F0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🖼 Product Image + ❤️ Wishlist Overlay
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    product['image']!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isWishlisted) {
                                          WishlistManager.removeItem(product);
                                        } else {
                                          WishlistManager.addItem(product);
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // ignore: deprecated_member_use
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            // ignore: deprecated_member_use
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 3,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                                        color: isWishlisted ? Colors.pink : Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 4),

                          // 🧾 Product Info
                          Text(
                            product['name']!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            product['price']!,
                            style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),

                          // 🛒 Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink[50],
                                    foregroundColor: Colors.pink,
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () {},
                                  child: const Text("Add to Cart", style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
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
                                  child: const Text("Buy Now", style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
