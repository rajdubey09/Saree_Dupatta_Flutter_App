import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:saree_dupatta/models/product_model.dart';
import 'package:saree_dupatta/screens/checkout_screen.dart';
import 'package:saree_dupatta/data/wishlist_manager.dart';
import '../data/cart_manager.dart';
import '../i18n/app_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WishlistManager wishlistManager = WishlistManager();

  int _currentBannerIndex = 0;

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
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// 🧠 This ensures cart syncs with SharedPreferences
  Future<void> _loadInitialData() async {
    await CartManager.initialize();
    await WishlistManager.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: const Text(AppStrings.appName),
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
      body: RefreshIndicator(
        onRefresh: _loadInitialData,
        child: SingleChildScrollView( 
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 3),

              // 🔹 Banner Carousel
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider.builder(
                    itemCount: bannerImages.length,
                    itemBuilder: (context, index, realIndex) {
                      final url = bannerImages[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 160,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentBannerIndex = index;
                        });
                      },
                    ),
                  ),

                  // 🔸 Dots Indicator (Overlay)
                  Positioned(
                    bottom: 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: bannerImages.asMap().entries.map((entry) {
                        bool isActive = entry.key == _currentBannerIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isActive ? 9.0 : 6.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : Colors.black.withOpacity(0.3), // 👈 clean visible dots
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
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
                    final productMap = products[index];
                    final product = Product(
                      // id: index.toString(),
                      name: productMap['name']!,
                      imageUrl: productMap['image']!,
                      price: double.parse(productMap['price']!.replaceAll('₹', '')),
                      // description: productMap['name']!,
                    );

                    final productAsMap = {
                      'name': product.name,
                      'price': '₹${product.price.toStringAsFixed(0)}',
                      'image': product.imageUrl,
                    };

                    final isWishlisted = WishlistManager.isInWishlist(productAsMap);
                    final isInCart = CartManager.isInCart(product);

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
                                      product.imageUrl,
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
                                      onTap: () async{
                                        setState(() {
                                          if (isWishlisted) {
                                            WishlistManager.removeItem(productAsMap);
                                          } else {
                                            WishlistManager.addItem(productAsMap);
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
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
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
                                    backgroundColor: isInCart ? Colors.grey[300] : Colors.pink[50],
                                    foregroundColor: isInCart ? Colors.grey[600] : Colors.pink,
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () async {
                                    if (isInCart) {
                                      await CartManager.removeFromCart(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Removed from Cart')),
                                      );
                                      } else {
                                        await CartManager.addToCart(product);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Added to Cart')),
                                        );
                                      }
                                      setState(() {});
                                    },
                                    child: Text(isInCart ? "Added" : "Add to Cart",
                                      style: const TextStyle(fontSize: 12),),
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
                                          'name': product.name,
                                          'price': '₹${product.price.toStringAsFixed(0)}',
                                          'quantity': 1,
                                          'image': product.imageUrl,
                                        }
                                      ];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CheckoutScreen(
                                            cartItems: singleItem,
                                            totalAmount: product.price
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
      )
    );
  }
}
