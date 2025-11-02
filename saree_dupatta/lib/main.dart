import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cart_screen.dart';
import 'package:saree_dupatta/data/wishlist_manager.dart'; 
import 'package:saree_dupatta/data/cart_manager.dart';
import 'i18n/app_strings.dart';
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await WishlistManager.initialize();
  await CartManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData(primarySwatch: Colors.pink),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
