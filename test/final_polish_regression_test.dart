import 'package:ecommerce_app/data/product_repository.dart';
import 'package:ecommerce_app/features/auth/sign_in_screen.dart';
import 'package:ecommerce_app/features/auth/sign_up_screen.dart';
import 'package:ecommerce_app/features/categories/categories_screen.dart';
import 'package:ecommerce_app/features/layout/main_layout.dart';
import 'package:ecommerce_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Sign In rejects empty fields and accepts nonempty demo input', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var authenticated = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SignInScreen(onAuthenticated: () => authenticated = true),
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(authenticated, isFalse);

    await tester.enterText(find.byType(TextField).at(0), 'Demo User');
    await tester.enterText(find.byType(TextField).at(1), 'demo-password');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(authenticated, isTrue);
  });

  testWidgets('Sign Up rejects empty fields', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(home: SignUpScreen(onAuthenticated: () {})),
    );

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your mobile number'), findsOneWidget);
    expect(find.text('Please enter your email address'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('valid Sign Up submits into Main Layout', (tester) async {
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
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Demo User');
    await tester.enterText(find.byType(TextField).at(1), '01234567890');
    await tester.enterText(find.byType(TextField).at(2), 'demo@example.com');
    await tester.enterText(find.byType(TextField).at(3), 'demo-password');
    await tester.ensureVisible(find.text('Sign up'));
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.byType(MainLayout), findsOneWidget);
  });

  testWidgets('bottom navigation selects all four main tabs', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: MainLayout()));
    await tester.pumpAndSettle();

    for (final tab in ['Home', 'Categories', 'Wishlist', 'Account']) {
      final tabFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == tab,
      );
      await tester.tap(tabFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<Semantics>(tabFinder).properties.selected, isTrue);
    }
  });

  test('repository search returns matches and no results as expected', () {
    const repository = ProductRepository();

    expect(repository.searchProducts('Nike'), isNotEmpty);
    expect(repository.searchProducts('no-such-product'), isEmpty);
  });

  testWidgets(
    'Categories adapts its grid at narrow widths and keeps normal layout',
    (tester) async {
      final errors = <FlutterErrorDetails>[];
      final previousOnError = FlutterError.onError;
      FlutterError.onError = errors.add;
      addTearDown(() => FlutterError.onError = previousOnError);

      Widget screen() => MaterialApp(
        home: Scaffold(
          body: CategoriesScreen(
            selectedCategory: "Men's Fashion",
            favoriteIds: <String>{},
            onCategorySelected: (_) {},
            onToggleFavorite: (_) {},
            onAddToCart: (_) {},
            onOpenProduct: (_) {},
            onOpenCart: () {},
            onNavigateTab: (_) {},
          ),
        ),
      );

      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      final narrowGrid = tester.widget<GridView>(find.byType(GridView));
      expect(
        (narrowGrid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
            .crossAxisCount,
        2,
      );

      tester.view.physicalSize = const Size(430, 932);
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      final normalGrid = tester.widget<GridView>(find.byType(GridView));
      expect(
        (normalGrid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
            .crossAxisCount,
        3,
      );
      final sidebar = find.byType(ListView).first;
      final sidebarLabels = tester
          .widgetList<Text>(
            find.descendant(of: sidebar, matching: find.byType(Text)),
          )
          .map((text) => text.data)
          .toList();
      expect(sidebarLabels, [
        "Men's Fashion",
        "Women's Fashion",
        'Skincare',
        'Beauty',
        'Headphones',
        'Cameras',
        'Laptops & Electronics',
        'Baby & Toys',
      ]);
      expect(errors, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
}
