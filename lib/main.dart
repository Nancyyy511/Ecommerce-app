import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/theme/app_theme.dart';
import 'core/navigation/app_route_observer.dart';
import 'features/layout/main_layout.dart';
import 'features/splash/splash_screen.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  runApp(const RouteApp());
}

class RouteApp extends StatelessWidget {
  const RouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      navigatorKey: _navigatorKey,
      navigatorObservers: [appRouteObserver],
      home: const AuthEntryPoint(),
    );
  }
}

class AuthEntryPoint extends StatelessWidget {
  const AuthEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      onAuthenticated: () {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge,
        ).catchError((Object _) {});
        _navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const MainLayout()),
          (route) => false,
        );
      },
    );
  }
}
