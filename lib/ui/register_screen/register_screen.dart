import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/assets/app_assets.dart';
import 'package:untitled1/ui/login_screen/login_screen.dart';
import 'package:untitled1/ui/home_screen/home_screen.dart';
import 'package:untitled1/ui/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildForm(),
                  const SizedBox(height: 40),
                  _isLoading
                      ? const CircularProgressIndicator(color: Color(0xFFB8C4A0))
                      : _buildCreateButton(),
                  const SizedBox(height: 20),
                  _buildFooter(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xFFF0F0F0),
          child: Icon(Icons.explore_outlined, color: Color(0xFF8BAE8E), size: 40),
        ),
        const SizedBox(height: 20),
        const Text('Join the Journey', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text('Create an account to start exploring', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _nameController,
          hint: 'Alex Thompson',
          iconData: Icons.person_outline,
          validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter your full name' : null,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _emailController,
          hint: 'alex@example.com',
          iconData: Icons.email_outlined,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Please enter your email';
            final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
            if (!emailValid) return 'Please enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _passwordController,
          hint: '********',
          iconData: Icons.lock_outline,
          isPassword: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Please enter a password';
            if (value.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _confirmPasswordController,
          hint: '********',
          iconData: Icons.lock_outline,
          isPassword: true,
          validator: (value) => (value != _passwordController.text) ? 'Passwords do not match' : null,
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB8C4A0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? ', style: TextStyle(color: Colors.grey)),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text('Login', style: TextStyle(color: Color(0xFFB8C4A0), fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _showResultDialog({required String title, required String message, bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: isSuccess ? Colors.green : Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isSuccess) Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (mounted) _showResultDialog(title: 'Success', message: 'Account created successfully! Please login.', isSuccess: true);
      } on FirebaseAuthException catch (e) {
        String message = e.code == 'weak-password'
            ? 'The password provided is too weak.'
            : e.code == 'email-already-in-use'
                ? 'The account already exists for that email.'
                : e.message ?? 'An error occurred';
        if (mounted) _showResultDialog(title: 'Registration Failed', message: message);
      } catch (e) {
        if (mounted) _showResultDialog(title: 'Error', message: e.toString());
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}
