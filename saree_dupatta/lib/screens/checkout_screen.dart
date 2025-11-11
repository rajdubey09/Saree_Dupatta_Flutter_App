import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saree_dupatta/screens/logintoplace.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const double platformCharge = 7.0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _addressController = TextEditingController(text: "");
  final TextEditingController _pincodeController = TextEditingController(text: "");
  final TextEditingController _phoneController = TextEditingController(text: "");
  final TextEditingController _gstController = TextEditingController(text: "");

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  bool _prefillLoading = true;
  bool _placingOrder = false;

  @override
  void initState() {
    super.initState();

    // Listen to auth state so screen updates if user signs in/out while here
    _auth.authStateChanges().listen((user) {
      _currentUser = user;
      if (user != null) {
        _fetchAndPrefillUserProfile(user.uid);
      } else {
        _clearPrefillFields();
        if (mounted) setState(() => _prefillLoading = false);
      }
    });

    // Try current user immediately
    final user = _auth.currentUser;
    if (user != null) {
      _currentUser = user;
      _fetchAndPrefillUserProfile(user.uid);
    } else {
      _prefillLoading = false;
    }
  }

  Future<void> _fetchAndPrefillUserProfile(String uid) async {
    setState(() {
      _prefillLoading = true;
    });

    try {
      final doc = await _firestore.collection('users').doc(uid).get(const GetOptions(source: Source.server));
      if (doc.exists) {
        final data = doc.data()!;

        // Name: prefer 'name' key, fallback to FirebaseAuth displayName
        _nameController.text = (data['name'] ?? _auth.currentUser?.displayName ?? '').toString();

        // Phone: prefer 'phone', fallback to 'contact'
        _phoneController.text = (data['phone'] ?? data['contact'] ?? '').toString();

        // Address: prefer combined 'address' string; else build from granular fields
        final combinedAddress = (data['address'] ?? '').toString().trim();
        if (combinedAddress.isNotEmpty) {
          _addressController.text = combinedAddress;
        } else {
          final parts = <String>[];
          final house = (data['house'] ?? '').toString().trim();
          final area = (data['area'] ?? '').toString().trim();
          final city = (data['city'] ?? '').toString().trim();
          final state = (data['state'] ?? '').toString().trim();
          if (house.isNotEmpty) parts.add(house);
          if (area.isNotEmpty) parts.add(area);
          if (city.isNotEmpty) parts.add(city);
          if (state.isNotEmpty) parts.add(state);
          _addressController.text = parts.join(', ');
        }

        // Pincode: try 'pincode' then 'pin'
        _pincodeController.text = (data['pincode'] ?? data['pin'] ?? '').toString();

        // GST if present (key 'gst')
        _gstController.text = (data['gst'] ?? '').toString();
      } else {
        // Document doesn't exist; optionally prefill name from auth
        _nameController.text = _auth.currentUser?.displayName ?? '';
      }
    } catch (e) {
      // If fetch fails silently allow manual entry
    } finally {
      if (mounted) setState(() => _prefillLoading = false);
    }
  }

  void _clearPrefillFields() {
    _nameController.text = "";
    _phoneController.text = "";
    _addressController.text = "";
    _pincodeController.text = "";
    _gstController.text = "";
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Please enter your name";
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return "Please enter your address";
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) return "Please enter pincode";
    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) return "Enter valid 6-digit pincode";
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null) return "Enter valid number";
    final v = value.trim();
    if (!RegExp(r'^\d{10}$').hasMatch(v)) return "Enter valid 10-digit number";
    return null;
  }

  String? _validateGst(String? value) {
    if (value == null || value.trim().isEmpty) return "Please enter Valid GST Number"; 
    final v = value.trim();
    if (v.length != 15) return "Enter valid 15-character GSTIN";
    return null;
  }

  Future<void> _onPlaceOrderPressed() async {
    if (!_formKey.currentState!.validate()) return;

    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login to place the order')));
      return;
    }

    setState(() {
      _placingOrder = true;
    });

    try {
      // TODO: save order to Firestore if you want persistent orders
      // For now navigate to OrderSuccessScreen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessScreen(
              name: _nameController.text.trim(),
              address: _addressController.text.trim(),
              phone: _phoneController.text.trim(),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
    } finally {
      if (mounted) setState(() => _placingOrder = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.pink.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _phoneController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double total = widget.totalAmount + platformCharge;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: _prefillLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Order Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Order Items
                  ...widget.cartItems.map((item) => Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item['image'] ?? '',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported, color: Colors.grey),
                            ),
                          ),
                          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Qty: ${item['quantity']}  |  ₹${item['price']}"),
                          trailing: Text(
                            "₹${(item['price'] * item['quantity'])}",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
                          ),
                        ),
                      )),

                  const Divider(thickness: 1.5),
                  const SizedBox(height: 10),

                  // Price Summary
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text("Subtotal", style: TextStyle(fontSize: 16)),
                    Text("₹${widget.totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text("Platform Charges", style: TextStyle(fontSize: 16)),
                    Text("₹${platformCharge.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("₹${total.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
                  ]),
                  const SizedBox(height: 15),

                  const Text("Shipping Address", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(controller: _nameController, decoration: _inputDecoration("Full Name"), validator: _validateName),
                        const SizedBox(height: 10),
                        TextFormField(controller: _addressController, decoration: _inputDecoration("Full Address"), validator: _validateAddress),
                        const SizedBox(height: 10),
                        TextFormField(controller: _pincodeController, decoration: _inputDecoration("Pincode"), keyboardType: TextInputType.number, validator: _validatePincode),
                        const SizedBox(height: 10),
                        TextFormField(controller: _phoneController, decoration: _inputDecoration("Mobile Number"), keyboardType: TextInputType.phone, validator: _validatePhone),
                        const SizedBox(height: 10),
                        TextFormField(controller: _gstController, decoration: _inputDecoration("GSTIN (optional)"), validator: _validateGst),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: _placingOrder
                        ? ElevatedButton.icon(
                            onPressed: null,
                            icon: const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                            label: const Text("Placing Order..."),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          )
                        : _currentUser == null
                            ? Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: null,
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                    child: const Text("Place Order", style: TextStyle(fontSize: 18, color: Colors.white)),
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const LoginToPlaceScreen()),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.pinkAccent), padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                    child: const Text("Login to Place Order", style: TextStyle(fontSize: 16, color: Colors.pinkAccent)),
                                  ),
                                ],
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                onPressed: _onPlaceOrderPressed,
                                child: const Text("Place Order", style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                  ),
                ],
              ),
            ),
    );
  }
}