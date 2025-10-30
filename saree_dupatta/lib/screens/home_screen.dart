import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:saree_dupatta/screens/checkout_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> bannerImages = [
      'https://images.unsplash.com/photo-1603898037225-01abff9f2e8f',
      'https://images.unsplash.com/photo-1620799140408-edc6dcb6c7d4',
      'https://images.unsplash.com/photo-1603884973818-29d038fcae23',
      'https://images.unsplash.com/photo-1604061986761-1b0e6c7f5a39',
    ];

    final List<Map<String, String>> products = [
      {'name': 'Banarasi Silk Saree', 'price': '₹1299', 'image': 'https://cdn.pixabay.com/photo/2017/09/01/02/06/saree-2703580_1280.jpg'},
      {'name': 'Cotton Printed Saree', 'price': '₹799', 'image': 'https://cdn.pixabay.com/photo/2018/03/12/22/48/saree-3222056_1280.jpg'},
      {'name': 'Designer Dupatta', 'price': '₹499', 'image': 'https://cdn.pixabay.com/photo/2015/06/24/15/45/indian-821485_1280.jpg'},
      {'name': 'Wedding Saree', 'price': '₹1999', 'image': 'https://cdn.pixabay.com/photo/2016/08/26/15/06/indian-1621400_1280.jpg'},
      {'name': 'Banarasi Silk Saree', 'price': '₹1299', 'image': 'https://cdn.pixabay.com/photo/2017/09/01/02/06/saree-2703580_1280.jpg'},
      {'name': 'Cotton Printed Saree', 'price': '₹799', 'image': 'https://cdn.pixabay.com/photo/2018/03/12/22/48/saree-3222056_1280.jpg'},
      {'name': 'Designer Dupatta', 'price': '₹499', 'image': 'https://cdn.pixabay.com/photo/2015/06/24/15/45/indian-821485_1280.jpg'},
      {'name': 'Wedding Saree', 'price': '₹1999', 'image': 'https://cdn.pixabay.com/photo/2016/08/26/15/06/indian-1621400_1280.jpg'},
      {'name': 'Banarasi Silk Saree', 'price': '₹1299', 'image': 'https://cdn.pixabay.com/photo/2017/09/01/02/06/saree-2703580_1280.jpg'},
      {'name': 'Cotton Printed Saree', 'price': '₹799', 'image': 'https://cdn.pixabay.com/photo/2018/03/12/22/48/saree-3222056_1280.jpg'},
      {'name': 'Designer Dupatta', 'price': '₹499', 'image': 'https://cdn.pixabay.com/photo/2015/06/24/15/45/indian-821485_1280.jpg'},
      {'name': 'Wedding Saree', 'price': '₹1999', 'image': 'https://cdn.pixabay.com/photo/2016/08/26/15/06/indian-1621400_1280.jpg'},
      {'name': 'Banarasi Silk Saree', 'price': '₹1299', 'image': 'https://cdn.pixabay.com/photo/2017/09/01/02/06/saree-2703580_1280.jpg'},
      {'name': 'Cotton Printed Saree', 'price': '₹799', 'image': 'https://cdn.pixabay.com/photo/2018/03/12/22/48/saree-3222056_1280.jpg'},
      {'name': 'Designer Dupatta', 'price': '₹499', 'image': 'https://cdn.pixabay.com/photo/2015/06/24/15/45/indian-821485_1280.jpg'},
      {'name': 'Wedding Saree', 'price': '₹1999', 'image': 'https://cdn.pixabay.com/photo/2016/08/26/15/06/indian-1621400_1280.jpg'},
    ];

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
            // 🔹 Carousel Section
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
                  child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
                );
              }).toList(),
            ),

            // const SizedBox(height: 5),

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
                  return Card(
                    color: const Color(0xFFFFF0F0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product['image']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
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
                                    final singleItem  = [
                                      {
                                        'name': product['name'], // replace with your variable
                                        'price': product['price'],
                                        'quantity': 1,
                                        'image': product['image'], // optional, if you have it
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
