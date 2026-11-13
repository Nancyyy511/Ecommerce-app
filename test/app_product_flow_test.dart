import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/features/cart/cart_screen.dart';
import 'package:ecommerce_app/features/layout/main_layout.dart';
import 'package:ecommerce_app/features/products/product_details_screen.dart';
import 'package:ecommerce_app/features/products/product_list_screen.dart';
import 'package:ecommerce_app/main.dart';

void main() {
  testWidgets('sign in, category, product details and shared cart flow works', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const RouteApp());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'enter your name',
      ),
      'Test user',
    );
    await tester.enterText(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'enter your password',
      ),
      'password',
    );
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.byType(MainLayout), findsOneWidget);
    expect(find.text('Home Appliance'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Footwear').first);
    await tester.tap(find.text('Footwear').first);
    await tester.pumpAndSettle();
    expect(find.byType(ProductListScreen), findsOneWidget);

    await tester.tap(find.text('Nike Air Jordon').first);
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailsScreen), findsOneWidget);
    await tester.tap(find.byTooltip('Add to wishlist'));
    await tester.tap(find.text('41'));
    await tester.tap(find.byTooltip('Select Orange color'));
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.tap(find.text('Add to cart'));
    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();

    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.text('Orange | Size: 41'), findsOneWidget);
    expect(find.text('EGP 2400'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(ProductListScreen), findsOneWidget);
    expect(find.byTooltip('Remove from wishlist'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Orange | Size: 41'), findsOneWidget);
    expect(find.text('Black | Size: 40'), findsOneWidget);
    expect(find.text('EGP 3600'), findsOneWidget);
  });
}
