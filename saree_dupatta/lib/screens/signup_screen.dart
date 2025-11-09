import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _companyController = TextEditingController();

  bool _isLoading = false;

  // ----------------- SIGNUP LOGIC -----------------
  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1️⃣ Create user account in Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user!.updateDisplayName(
        _fullNameController.text.trim(),
      );
      await userCredential.user!.reload();

      // 2️⃣ Save additional user details in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'fullName': _fullNameController.text.trim(),
        'contact': _contactController.text.trim(),
        'company': _companyController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3️⃣ Toast confirmation
      Fluttertoast.showToast(
        msg:
            "Account created successfully! Welcome ${_fullNameController.text.trim()} 👋",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green.shade600,
        textColor: Colors.white,
        fontSize: 16,
      );

      // 4️⃣ Navigate to Login Screen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? "Signup failed. Please check your details.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ----------------- INPUT STYLE -----------------
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.pink.shade800),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink.shade800, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  // ----------------- UI -----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.pink.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Sign up to continue using Saree Dupatta",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 30),

                // FORM
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _fullNameController,
                        decoration: _inputDecoration("Full Name", Icons.person),
                        validator: (v) =>
                            v!.isEmpty ? "Enter your full name" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _contactController,
                        decoration:
                            _inputDecoration("Contact Number", Icons.phone),
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            v!.isEmpty ? "Enter your contact number" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _companyController,
                        decoration:
                            _inputDecoration("Company Name", Icons.business),
                        validator: (v) =>
                            v!.isEmpty ? "Enter your company name" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration("Email", Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            v!.isEmpty ? "Enter your email" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        decoration: _inputDecoration("Password", Icons.lock),
                        obscureText: true,
                        validator: (v) => v == null || v.length < 8
                            ? "Password must be at least 8 characters"
                            : null,
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: _isLoading ? null : _signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ) :
                            const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                // TextButton(
                //   onPressed: () {
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => const LoginScreen(),
                //       ),
                //     );
                //   },
                //   child: const Text(
                //     "Already have an account? Login",
                //     style: TextStyle(
                //       color: Colors.pink,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
                // Login navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
