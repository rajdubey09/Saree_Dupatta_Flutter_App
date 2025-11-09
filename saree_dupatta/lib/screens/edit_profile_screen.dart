import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfileDialog extends StatefulWidget {
  final User? user;
  const EditProfileDialog({super.key, required this.user});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final houseController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = widget.user;
    if (user == null) return;

    nameController.text = user.displayName ?? '';

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data();
      contactController.text = data?['contact'] ?? '';
      houseController.text = data?['house'] ?? '';
      areaController.text = data?['area'] ?? '';
      cityController.text = data?['city'] ?? '';
      stateController.text = data?['state'] ?? '';
      pinController.text = data?['pin'] ?? '';
    }
  }

  Future<void> _submitProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await user.updateDisplayName(nameController.text);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': nameController.text,
        'contact': contactController.text,
        'house': houseController.text,
        'area': areaController.text,
        'city': cityController.text,
        'state': stateController.text,
        'pin': pinController.text,
        'email': user.email,
      }, SetOptions(merge: true));

      Fluttertoast.showToast(
        msg: "Profile updated successfully 🎉",
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
      );

      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Update failed: $e",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(20),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Edit Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
            const SizedBox(height: 20),

            TextFormField(
              initialValue: widget.user?.email ?? '',
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.pinkAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person_outline, color: Colors.pinkAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                prefixIcon: const Icon(Icons.phone_outlined, color: Colors.pinkAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            const Divider(),
            const Text("Address", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 10),

            TextField(controller: houseController, decoration: _addressInput("House/Flat No")),
            const SizedBox(height: 8),
            TextField(controller: areaController, decoration: _addressInput("Area")),
            const SizedBox(height: 8),
            TextField(controller: cityController, decoration: _addressInput("City")),
            const SizedBox(height: 8),
            TextField(controller: stateController, decoration: _addressInput("State")),
            const SizedBox(height: 8),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              decoration: _addressInput("Pin Code"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _submitProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Submit", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  InputDecoration _addressInput(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}