import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_logo.dart';
import 'sign_up_screen.dart';
import 'widgets/auth_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.onAuthenticated});

  final VoidCallback onAuthenticated;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) widget.onAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 72),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: AppLogo(white: true, width: 237)),
                    const SizedBox(height: 72),
                    const Text('Welcome Back To Route', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w600)),
                    const Text('Please sign in with your mail', style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 34),
                    AuthTextField(
                      label: 'User Name', hint: 'enter your name', controller: _nameController,
                      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 28),
                    AuthTextField(
                      label: 'Password', hint: 'enter your password', controller: _passwordController,
                      obscureText: _hidePassword,
                      onToggleVisibility: () => setState(() => _hidePassword = !_hidePassword),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password recovery is not available yet.')),
                        ),
                        child: const Text('Forgot password', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 36),
                    AppButton(label: 'Login', onPressed: _login),
                    const SizedBox(height: 24),
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text('Don’t have an account? ', style: TextStyle(color: Colors.white, fontSize: 16)),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (_) => SignUpScreen(onAuthenticated: widget.onAuthenticated),
                            )),
                            child: const Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
