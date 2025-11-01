class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  // Convert a Product to Map (for saving in SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Convert Map back to Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // Helpful for comparing products uniquely by name and image
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.name == name && other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => name.hashCode ^ imageUrl.hashCode;
}
