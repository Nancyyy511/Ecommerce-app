import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_app/features/auth/sign_in_screen.dart';
import 'package:ecommerce_app/features/auth/sign_up_screen.dart';
import 'package:ecommerce_app/features/splash/splash_screen.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/data/product_repository.dart';

void main() {
  testWidgets('app starts on the splash screen and opens sign in', (
    tester,
  ) async {
    await tester.pumpWidget(const RouteApp());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.text('Welcome Back To Route'), findsOneWidget);
  });

  testWidgets('sign in can open the sign up screen', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const RouteApp());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
  });

  test('repository filters products by the selected subcategory', () {
    const repository = ProductRepository();

    final footwear = repository.searchProducts(
      '',
      category: "Men's Fashion",
      subcategory: 'Footwear',
    );

    expect(footwear, isNotEmpty);
    expect(
      footwear.every((product) => product.subcategory == 'Footwear'),
      isTrue,
    );
  });

  test('home appliance sample products are available to the home section', () {
    const repository = ProductRepository();

    final appliances = repository.getProductsByCategory('Home Appliance');

    expect(appliances, hasLength(3));
    expect(
      appliances.map((product) => product.subcategory),
      containsAll(['Washing Machines', 'Cooktops', 'Irons']),
    );
  });
}
