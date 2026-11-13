import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_logo.dart';
import 'widgets/auth_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.onAuthenticated});

  final VoidCallback onAuthenticated;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? 'Please enter $label' : null;

  void _register() {
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
                    const SizedBox(height: 38),
                    AuthTextField(label: 'Full Name', hint: 'enter your full name', controller: _name,
                      validator: (value) => _required(value, 'your full name')),
                    const SizedBox(height: 26),
                    AuthTextField(label: 'Mobile Number', hint: 'enter your mobile no.', controller: _mobile,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        final required = _required(value, 'your mobile number');
                        if (required != null) return required;
                        return RegExp(r'^\+?[0-9]{8,15}$').hasMatch(value!.replaceAll(RegExp(r'\s'), ''))
                            ? null : 'Enter a valid mobile number';
                      }),
                    const SizedBox(height: 26),
                    AuthTextField(label: 'E-mail address', hint: 'enter your email address', controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        final required = _required(value, 'your email address');
                        if (required != null) return required;
                        return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!)
                            ? null : 'Enter a valid email address';
                      }),
                    const SizedBox(height: 26),
                    AuthTextField(label: 'Password', hint: 'enter your password', controller: _password,
                      obscureText: _hidePassword,
                      onToggleVisibility: () => setState(() => _hidePassword = !_hidePassword),
                      validator: (value) {
                        final required = _required(value, 'a password');
                        if (required != null) return required;
                        return value!.length >= 6 ? null : 'Use at least 6 characters';
                      }),
                    const SizedBox(height: 56),
                    AppButton(label: 'Sign up', onPressed: _register),
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
