import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saree Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> carouselImages = [
    'https://via.placeholder.com/400x150.png?text=Festival+Offer+1',
    'https://via.placeholder.com/400x150.png?text=Sale+Up+to+50%25+Off',
    'https://via.placeholder.com/400x150.png?text=New+Arrivals',
    'https://via.placeholder.com/400x150.png?text=Wedding+Collection',
    'https://via.placeholder.com/400x150.png?text=Exclusive+Dupattas',
  ];

  final List<Map<String, String>> products = [
    {
      'name': 'Banarasi Silk Saree',
      'price': '₹1299',
      'image': 'https://www.google.com/url?sa=i&url=https%3A%2F%2Flajreedesigner.com%2Fproducts%2Fbollywood-style-purple-cotton-silk-saree-with-majestic-blouse-piece&psig=AOvVaw2XdbJQMT6d3kBGiMRPH2KW&ust=1761668338387000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwjcz7iN5MSQAxU-QGwGHdDyEikQjRx6BAgAEBo',
    },
    {
      'name': 'Cotton Printed Saree',
      'price': '₹799',
      'image': 'https://via.placeholder.com/150x120.png?text=Saree+2',
    },
    {
      'name': 'Georgette Saree',
      'price': '₹999',
      'image': 'https://via.placeholder.com/150x120.png?text=Saree+3',
    },
    {
      'name': 'Designer Dupatta',
      'price': '₹499',
      'image': 'https://via.placeholder.com/150x120.png?text=Dupatta',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saree & Dupatta Shop'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // 👇 Navigate to Cart Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // 👇 Navigate to Profile Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔥 Carousel Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 160.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.95,
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: carouselImages.map((item) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    }).toList(),
                  ),

                  // 🔘 Dot Indicators
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: carouselImages.asMap().entries.map((entry) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentIndex == entry.key ? 10.0 : 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? Colors.pinkAccent
                              : Colors.pinkAccent.withOpacity(0.3),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // 🛍️ Product Grid Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 4,
                    color: const Color(0xFFFFF0F0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🖼 Product Image
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            product['image']!,
                            fit: BoxFit.cover,
                            height: 130,
                            width: double.infinity,
                          ),
                        ),

                        const Spacer(),

                        // 📛 Product Name
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // 💰 Price
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Text(
                            product['price']!,
                            style: const TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

// 🧍‍♂️ PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage('https://via.placeholder.com/100.png?text=Profile'),
            ),
            SizedBox(height: 20),
            Text(
              'Your Name Here',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('sareeshop@gmail.com'),
          ],
        ),
      ),
    );
  }
}



// 🧍‍♂️ Cart SCREEN
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage('https://via.placeholder.com/100.png?text=Cart'),
            ),
            SizedBox(height: 20),
            Text(
              'Cart Screen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('sareeshop@gmail.com'),
          ],
        ),
      ),
    );
  }
}
