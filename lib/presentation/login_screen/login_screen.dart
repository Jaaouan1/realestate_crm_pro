import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/biometric_login_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_header_widget.dart';
import './widgets/social_login_widget.dart';
import 'widgets/biometric_login_widget.dart';
import 'widgets/login_form_widget.dart';
import 'widgets/login_header_widget.dart';
import 'widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadSavedCredentials();
  }

  Future<void> _checkBiometricAvailability() async {
    // Check if biometric authentication is available
    // This would typically use local_auth package
    setState(() {
      _isBiometricAvailable = true; // Simulated
    });
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (savedEmail != null && rememberMe) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberMe = rememberMe;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate authentication API call
      await Future.delayed(const Duration(seconds: 2));

      // Save credentials if remember me is checked
      if (_rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_email', _emailController.text);
        await prefs.setBool('remember_me', true);
      }

      // Save authentication status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_authenticated', true);
      await prefs.setString('user_email', _emailController.text);

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.propertyDashboard);
      }
    } catch (e) {
      _showErrorMessage('Login failed. Please check your credentials.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    try {
      setState(() => _isLoading = true);

      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_authenticated', true);

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.propertyDashboard);
      }
    } catch (e) {
      _showErrorMessage('Biometric authentication failed.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() => _isLoading = true);

    try {
      // Simulate social login
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_authenticated', true);
      await prefs.setString('login_provider', provider);

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.propertyDashboard);
      }
    } catch (e) {
      _showErrorMessage('$provider login failed.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset Password',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your email address to receive password reset instructions.',
              style: GoogleFonts.inter(),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage(
                  'Password reset instructions sent to your email.');
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.onPrimary,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 4.h),

              // Header
              const LoginHeaderWidget(),

              SizedBox(height: 6.h),

              // Login Form
              LoginFormWidget(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                focusEmail: _focusEmail,
                focusPassword: _focusPassword,
                isPasswordVisible: _isPasswordVisible,
                isLoading: _isLoading,
                rememberMe: _rememberMe,
                onPasswordVisibilityToggle: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
                onRememberMeChanged: (value) {
                  setState(() => _rememberMe = value ?? false);
                },
                onLogin: _handleLogin,
                onForgotPassword: _handleForgotPassword,
              ),

              SizedBox(height: 4.h),

              // Biometric Login
              if (_isBiometricAvailable) ...[
                BiometricLoginWidget(
                  isLoading: _isLoading,
                  onBiometricLogin: _handleBiometricLogin,
                ),
                SizedBox(height: 4.h),
              ],

              // Social Login
              SocialLoginWidget(
                isLoading: _isLoading,
                onSocialLogin: _handleSocialLogin,
              ),

              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}