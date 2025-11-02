// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:saree_dupatta/screens/wishlist_screen.dart';
import 'cart_screen.dart';
import 'package:saree_dupatta/data/wishlist_manager.dart';
import '../i18n/app_strings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
        backgroundColor: Colors.pinkAccent,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 👤 Profile Header (left avatar, right details + edit)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150x150.png?text=Profile'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Raj Dubey',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'raj.sareeshop@gmail.com',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                          label: const Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Edit Profile coming soon...')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // const SizedBox(height: 15),

            // 📦 My Account Section
            _buildSectionTitle("My Account"),
            _buildOptionTile(
              icon: Icons.shopping_bag_outlined,
              title: AppStrings.myOrders,
              subtitle: "View all your orders",
              onTap: () {
                // TODO: navigate to Orders screen
              },
            ),
            _buildOptionTile(
              icon: Icons.shopping_cart_outlined,
              title: AppStrings.cartTitle,
              subtitle: "Items you added to your cart",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            _buildOptionTile(
              icon: Icons.favorite_border,
              title: AppStrings.myWishlist,
              subtitle: "Your saved favourites",
              onTap: () {
                final wishlistItems = WishlistManager.getWishlist();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WishlistScreen(wishlistItems: wishlistItems)),
                );
              },
            ),

            // const SizedBox(height: 15),

            // 🏠 Address & Payment Section
            _buildSectionTitle("Settings"),
            _buildOptionTile(
              icon: Icons.location_on_outlined,
              title: "Saved Addresses",
              subtitle: "Your delivery locations",
              onTap: () {
                // TODO: navigate to Addresses
              },
            ),
            _buildOptionTile(
              icon: Icons.payment_outlined,
              title: "Payment Methods",
              subtitle: "UPI, Cards, Wallets",
              onTap: () {
                // TODO: navigate to Payment Methods
              },
            ),

            // const SizedBox(height: 15),

            // ⚙️ More Options
            _buildSectionTitle("More"),
            _buildOptionTile(
              icon: Icons.settings_outlined,
              title: "App Settings",
              subtitle: "Language, Notifications, etc.",
              onTap: () {
                // TODO: navigate to app settings
              },
            ),
            _buildOptionTile(
              icon: Icons.logout,
              title: AppStrings.logout,
              subtitle: "Sign out from your account",
              iconColor: Colors.redAccent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(AppStrings.logout),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Logged out successfully")),
                          );
                          // TODO: perform actual logout (Firebase signOut etc.) when integrated
                        },
                        child: const Text(AppStrings.logout),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
            const Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
  }

  // List Tile Widget for options (keeps signature same as your original)
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = Colors.pinkAccent,
  }) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
