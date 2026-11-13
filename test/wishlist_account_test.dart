import 'package:ecommerce_app/features/account/account_screen.dart';
import 'package:ecommerce_app/features/layout/main_layout.dart';
import 'package:ecommerce_app/features/wishlist/wishlist_screen.dart';
import 'package:ecommerce_app/data/dummy_data.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a Home favorite appears in Wishlist and can be removed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: MainLayout()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add to wishlist').first);
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Wishlist'));
    await tester.pumpAndSettle();

    expect(find.byType(WishlistScreen), findsOneWidget);
    expect(find.text('Front Load Washing Machine'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove from wishlist'));
    await tester.pumpAndSettle();

    expect(find.text('Your wishlist is empty'), findsOneWidget);
  });

  testWidgets('Account renders dummy profile and allows a local field edit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AccountScreen(user: DummyData.user)),
      ),
    );

    expect(find.text('Welcome, Mohamed'), findsOneWidget);
    expect(find.text(DummyData.user.email), findsWidgets);
    expect(find.text('Your full name'), findsOneWidget);
    expect(find.text(DummyData.user.fullName), findsOneWidget);
    expect(find.text('Your password'), findsOneWidget);
    expect(find.text('**********************'), findsOneWidget);
    expect(find.text('Your mobile number'), findsOneWidget);
    expect(find.text(DummyData.user.address), findsOneWidget);

    await tester.tap(find.byTooltip('Edit').first);
    await tester.pumpAndSettle();
    expect(find.text('Edit full name'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Mohamed Updated');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Mohamed Updated'), findsOneWidget);
  });

  testWidgets('Account email stays in sync and password remains masked', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AccountScreen(user: DummyData.user)),
      ),
    );

    await tester.tap(find.byTooltip('Edit').at(1));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'new@example.com');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('new@example.com'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Edit').at(2));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'new-secret');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('**********************'), findsOneWidget);
    expect(find.text('new-secret'), findsNothing);
  });

  testWidgets('Wishlist shows distinct empty and no-search-results states', (
    tester,
  ) async {
    final favoriteIds = <String>{};

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WishlistScreen(
            favoriteIds: favoriteIds,
            onToggleFavorite: (product) => favoriteIds.remove(product.id),
            onAddToCart: (_) {},
            onOpenProduct: (_) {},
            onOpenCart: () {},
          ),
        ),
      ),
    );

    expect(find.text('Your wishlist is empty'), findsOneWidget);
    expect(find.text('No products found'), findsNothing);

    favoriteIds.add(DummyData.products.first.id);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WishlistScreen(
            favoriteIds: favoriteIds,
            onToggleFavorite: (product) => favoriteIds.remove(product.id),
            onAddToCart: (_) {},
            onOpenProduct: (_) {},
            onOpenCart: () {},
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'no-such-product');
    await tester.pumpAndSettle();
    expect(find.text('Your wishlist is empty'), findsNothing);
    expect(find.text('No products found'), findsOneWidget);

    await tester.tap(find.text('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('Nike Air Jordon'), findsOneWidget);
  });

  testWidgets(
    'Wishlist can add a favorite product to the shared cart callback',
    (tester) async {
      final favoriteIds = <String>{DummyData.products.first.id};
      Product? addedProduct;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WishlistScreen(
              favoriteIds: favoriteIds,
              onToggleFavorite: (product) => favoriteIds.remove(product.id),
              onAddToCart: (product) => addedProduct = product,
              onOpenProduct: (_) {},
              onOpenCart: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add to Cart'));
      expect(addedProduct?.id, DummyData.products.first.id);
    },
  );
}
