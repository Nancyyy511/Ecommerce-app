import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../auth/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onAuthenticated});

  final VoidCallback onAuthenticated;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;
  bool _isPreparingSplash = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isPreparingSplash) return;
    _isPreparingSplash = true;

    // Keep the native launch screen until the Flutter logo is ready to show.
    precacheImage(const AssetImage(AppAssets.whiteLogo), context).then((_) {
      if (!mounted) return;
      if (!kIsWeb) FlutterNativeSplash.remove();
      _navigationTimer = Timer(const Duration(milliseconds: 900), _openSignIn);
    });
  }

  void _openSignIn() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => SignInScreen(onAuthenticated: widget.onAuthenticated),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.05, 0.98),
              radius: 1.2,
              colors: [Color(0xFF7194B4), AppColors.primary],
              stops: [0, 1],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.95, -0.85),
                    radius: 1.1,
                    colors: [Color(0xFF648AAD), Colors.transparent],
                    stops: [0, 1],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: Image.asset(
                    AppAssets.whiteLogo,
                    width: 320,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
