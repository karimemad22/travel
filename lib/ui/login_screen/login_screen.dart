import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/core/assets/app_assets.dart';
import 'package:untitled1/ui/register_screen/register_screen.dart';
import 'package:untitled1/ui/home_screen/home_screen.dart';
import 'package:untitled1/ui/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8BAE8E),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildBackgroundImage(),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildAppBar(),
                  const SizedBox(height: 20),
                  _buildLoginForm(),
                  const SizedBox(height: 30),
                  _buildFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Opacity(
        opacity: 0.5,
        child: Image.asset(
          AppAssets.photoTravel,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Text(
            'Sign In',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.navigaIcon,
              height: 40,
              colorFilter: const ColorFilter.mode(Colors.orange, BlendMode.srcIn),
            ),
            const SizedBox(height: 10),
            const Text('Travel Me', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 30),
            const Text('Welcome Back!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF6D8B6D))),
            const Text('Sign in to your account.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            CustomTextField(
              controller: _emailController,
              hint: 'Email',
              iconPath: AppAssets.userIcon,
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter your email' : null,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              hint: 'Password',
              iconPath: AppAssets.lockIcon,
              isPassword: true,
              isPasswordVisible: _isPasswordVisible,
              onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter your password' : null,
            ),
            _buildForgotPasswordBtn(),
            const SizedBox(height: 20),
            _isLoading ? const CircularProgressIndicator(color: Color(0xFF6D8B6D)) : _buildLoginButton(),
            const SizedBox(height: 30),
            const Text('OR SIGN IN WITH', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildSocialButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text('Forgot Password?', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6D8B6D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialIcon(Icons.g_mobiledata, Colors.red, onTap: _signInWithGoogle),
        const SizedBox(width: 20),
        _socialIconSvg(AppAssets.facebookIcon, Colors.blue),
      ],
    );
  }

  Widget _socialIcon(IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Color(0xFFE8F0E8), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  Widget _socialIconSvg(String asset, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Color(0xFFE8F0E8), shape: BoxShape.circle),
      child: SvgPicture.asset(asset, height: 25, width: 25, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ", style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RegisterScreen.routeName),
          child: const Text("Create one →", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
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
              if (isSuccess) Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) _showResultDialog(title: 'Success', message: 'Logged in successfully!', isSuccess: true);
      } on FirebaseAuthException catch (e) {
        String message = (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'wrong-password')
            ? 'Invalid email or password.'
            : e.message ?? 'Authentication failed';
        if (mounted) _showResultDialog(title: 'Login Failed', message: message);
      } catch (e) {
        if (mounted) _showResultDialog(title: 'Error', message: e.toString());
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } catch (e) {
      if (mounted) _showResultDialog(title: 'Google Sign-In Failed', message: e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
