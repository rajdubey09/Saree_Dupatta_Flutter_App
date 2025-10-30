import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController =
      TextEditingController(text: "Raj Dubey");
  final TextEditingController _addressController = TextEditingController(
      text: "Vedmanpur Parsipur, Bhadohi, Uttar Pradesh");
  final TextEditingController _pincodeController =
      TextEditingController(text: "221402");
  final TextEditingController _phoneController =
      TextEditingController(text: "9305511386");
  final TextEditingController _gstController =
      TextEditingController(text: "************");

  @override
  Widget build(BuildContext context) {
    double deliveryCharge = 49;
    double total = widget.totalAmount + deliveryCharge;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Order Items
            ...widget.cartItems.map((item) => Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                            const Icon(Icons.image_not_supported,
                                color: Colors.grey),
                      ),
                    ),
                    title: Text(item['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle:
                        Text("Qty: ${item['quantity']}  |  ₹${item['price']}"),
                    trailing: Text(
                      "₹${(item['price'] * item['quantity'])}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                )),

            const Divider(thickness: 1.5),
            const SizedBox(height: 10),

            // Price Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal", style: TextStyle(fontSize: 16)),
                Text("₹${widget.totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Delivery Charges", style: TextStyle(fontSize: 16)),
                Text("₹${deliveryCharge.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Amount",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  "₹${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Editable Address Section
            const Text(
              "Shipping Address",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration("Full Name"),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter your name" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: _inputDecoration("Full Address"),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter your address" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _pincodeController,
                    decoration: _inputDecoration("Pincode"),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? "Please enter pincode" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration("Mobile Number"),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value!.length != 10 ? "Enter valid number" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _gstController,
                    decoration: _inputDecoration("GTS"),
                    validator: (value) =>
                        value!.length != 12 ? "Enter valid GST" : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSuccessScreen(
                          name: _nameController.text,
                          address: _addressController.text,
                          phone: _phoneController.text,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Place Order",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}
