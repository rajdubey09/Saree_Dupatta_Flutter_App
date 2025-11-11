// Need to fix Signup data update while signup using checkout screen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginToPlaceScreen extends StatefulWidget {
  const LoginToPlaceScreen({super.key});

  @override
  State<LoginToPlaceScreen> createState() => _LoginToPlaceScreenState();
}

class _LoginToPlaceScreenState extends State<LoginToPlaceScreen> {
  final _formKey = GlobalKey<FormState>();

  // Shared controllers
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  // Signup-only controllers (matching your SignupScreen)
  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _contactCtrl = TextEditingController();
  final TextEditingController _companyCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController(); // optional if you want store address at signup

  bool _loading = false;
  bool _isSignup = false; // toggle between login and signup modes

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _fullNameCtrl.dispose();
    _contactCtrl.dispose();
    _companyCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: Colors.pinkAccent) : null,
      filled: true,
      fillColor: Colors.pink.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      if (mounted) Navigator.pop(context); // Checkout listens to auth changes and will prefill
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No account found. Please sign up.'), backgroundColor: Colors.orangeAccent),
          );
          setState(() => _isSignup = true);
        }
      } else if (e.code == 'wrong-password') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong password provided'), backgroundColor: Colors.pinkAccent),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${e.message ?? e.code}'), backgroundColor: Colors.pinkAccent),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login error: $e'), backgroundColor: Colors.pinkAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final email = _emailCtrl.text.trim();
      final password = _passwordCtrl.text;
      final fullName = _fullNameCtrl.text.trim();
      final contact = _contactCtrl.text.trim();
      final company = _companyCtrl.text.trim();
      final address = _addressCtrl.text.trim();

      // 1️⃣ Create user in Firebase Auth
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = cred.user;
      if (user == null) throw Exception('User creation failed');

      // 2️⃣ Update displayName same as your SignupScreen
      if (fullName.isNotEmpty) {
        await user.updateDisplayName(fullName);
        await user.reload();
      }

      // 3️⃣ Save additional details in Firestore using the same keys as SignupScreen
      final docRef = _firestore.collection('users').doc(user.uid);
      await docRef.set({
        'fullName': fullName,
        'contact': contact,
        'company': company,
        'email': email,
        'address': address,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 4️⃣ Ensure auth/profile/doc are settled before returning to Checkout
      await _auth.currentUser?.reload();
      await Future.delayed(const Duration(milliseconds: 400));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created and logged in'), backgroundColor: Colors.pinkAccent),
        );
        Navigator.pop(context); // Checkout's auth listener will fetch and prefill
      }
    } on FirebaseAuthException catch (e) {
      String msg = e.message ?? e.code;
      if (e.code == 'email-already-in-use') msg = 'Email already in use. Try login.';
      if (e.code == 'weak-password') msg = 'Password too weak (min 6 chars).';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup failed: $msg'), backgroundColor: Colors.pinkAccent));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup error: $e'), backgroundColor: Colors.pinkAccent));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextFormField(
          controller: _emailCtrl,
          decoration: _dec('Email', icon: Icons.email_outlined),
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter email';
            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) return 'Enter valid email';
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _passwordCtrl,
          decoration: _dec('Password', icon: Icons.lock_outline),
          obscureText: true,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Enter password';
            if (v.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _signIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: _loading
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _loading ? null : () => setState(() => _isSignup = true),
          child: Text('Don\'t have an account? Sign up', style: TextStyle(color: Colors.pinkAccent)),
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Column(
      children: [
        TextFormField(
          controller: _emailCtrl,
          decoration: _dec('Email', icon: Icons.email_outlined),
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter email';
            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) return 'Enter valid email';
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _passwordCtrl,
          decoration: _dec('Password', icon: Icons.lock_outline),
          obscureText: true,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Enter password';
            if (v.length < 8) return 'Password must be at least 8 characters';
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _fullNameCtrl,
          decoration: _dec('Full Name', icon: Icons.person_outline),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter your full name';
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _addressCtrl,
          decoration: _dec('Full Address', icon: Icons.home_outlined),
          keyboardType: TextInputType.streetAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter your address';
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _contactCtrl,
          decoration: _dec('Contact Number', icon: Icons.phone_outlined),
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter contact number';
            if (!RegExp(r'^\d{10}$').hasMatch(v.trim())) return 'Enter valid 10-digit phone';
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _companyCtrl,
          decoration: _dec('Company Name', icon: Icons.business),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: _loading
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : const Text('Sign up and Continue', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _loading ? null : () => setState(() => _isSignup = false),
          child: Text('Already have an account? Login', style: TextStyle(color: Colors.pinkAccent)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignup ? 'Sign up' : 'Login'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: _isSignup ? _buildSignupForm() : _buildLoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}