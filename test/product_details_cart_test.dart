import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/data/product_repository.dart';
import 'package:ecommerce_app/features/products/product_details_screen.dart';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/cart_state.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/features/cart/cart_screen.dart';

void main() {
  final product = const ProductRepository().getProductById('shoe-1')!;

  testWidgets(
    'product details carousel, options, quantity and add-to-cart work',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var favoriteChanges = 0;
      Product? addedProduct;
      var addedQuantity = 0;
      String? addedSize;
      String? addedColor;
      var addedColorValue = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsScreen(
            product: product,
            isFavorite: false,
            onToggleFavorite: (_) => favoriteChanges++,
            onAddToCart: (item, quantity, size, color, colorValue) {
              addedProduct = item;
              addedQuantity = quantity;
              addedSize = size;
              addedColor = color;
              addedColorValue = colorValue;
            },
            onOpenCart: () {},
          ),
        ),
      );

      expect(find.bySemanticsLabel('Product image 1 of 1'), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsNothing);
      final visibleImage = tester.widget<Image>(
        find.descendant(
          of: find.byType(PageView),
          matching: find.byType(Image),
        ),
      );
      expect((visibleImage.image as AssetImage).assetName, product.imagePath);

      await tester.tap(find.text('Read More'));
      await tester.pumpAndSettle();
      expect(find.text('Read Less'), findsOneWidget);
      await tester.tap(find.text('Read Less'));

      await tester.tap(find.text('41'));
      await tester.tap(find.byTooltip('Select Orange color'));
      await tester.tap(find.byTooltip('Increase quantity'));
      await tester.pumpAndSettle();
      expect(find.text('EGP 2400'), findsOneWidget);

      await tester.tap(find.byTooltip('Add to wishlist'));
      await tester.pumpAndSettle();
      expect(favoriteChanges, 1);

      await tester.tap(find.text('Add to cart'));
      await tester.pumpAndSettle();
      expect(addedProduct, product);
      expect(addedQuantity, 2);
      expect(addedSize, '41');
      expect(addedColor, 'Orange');
      expect(addedColorValue, 0xFFC33115);
      expect(find.text('Nike Air Jordon added to cart'), findsOneWidget);
    },
  );

  testWidgets('a product gallery uses only its configured images', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final galleryProduct = Product(
      id: product.id,
      name: product.name,
      imagePath: product.imagePath,
      galleryImagePaths: [product.imagePath!, product.imagePath!],
      price: product.price,
      oldPrice: product.oldPrice,
      category: product.category,
      subcategory: product.subcategory,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProductDetailsScreen(
          product: galleryProduct,
          isFavorite: false,
          onToggleFavorite: (_) {},
          onAddToCart: (_, _, _, _, _) {},
          onOpenCart: () {},
        ),
      ),
    );

    expect(find.bySemanticsLabel('Product image 1 of 2'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('selected-product-image-indicator-0')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('product-image-indicator-1')),
      findsOneWidget,
    );
  });

  testWidgets('cart updates totals and quantities, removes items and empties', (
    tester,
  ) async {
    final cart = CartState()
      ..add(
        const CartItem(
          productId: 'shoe-1',
          quantity: 2,
          size: '40',
          colorName: 'Orange',
          colorValue: 0xFFC33115,
        ),
      );

    await tester.pumpWidget(
      MaterialApp(
        home: CartScreen(cartState: cart, onCartChanged: () {}),
      ),
    );

    expect(find.text('EGP 2400'), findsOneWidget);
    expect(find.text('Orange | Size: 40'), findsOneWidget);
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pumpAndSettle();
    expect(find.text('EGP 3600'), findsOneWidget);

    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pumpAndSettle();
    expect(find.text('EGP 1200'), findsNWidgets(2));
    expect(cart.items.single.quantity, 1);

    await tester.tap(find.byTooltip('Remove Nike Air Jordon'));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('EGP 0'), findsOneWidget);
    await tester.tap(find.text('Check Out'));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is empty.'), findsOneWidget);
  });
}
