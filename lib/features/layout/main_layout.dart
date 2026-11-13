import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/product.dart';
import '../../models/cart_item.dart';
import '../../models/cart_state.dart';
import '../categories/categories_screen.dart';
import '../cart/cart_screen.dart';
import '../home/home_screen.dart';
import '../products/product_details_screen.dart';
import '../account/account_screen.dart';
import '../wishlist/wishlist_screen.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  String _selectedCategory = "Men's Fashion";
  final Set<String> _favoriteIds = {};
  final CartState _cartState = CartState();

  void _toggleFavorite(Product product) {
    setState(() {
      if (!_favoriteIds.add(product.id)) _favoriteIds.remove(product.id);
    });
  }

  void _addQuickToCart(Product product) {
    _addSelectedToCart(
      product,
      1,
      product.subcategory == 'Footwear' ? '40' : null,
      product.colorName,
      product.colorValue,
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
  }

  void _addSelectedToCart(
    Product product,
    int quantity,
    String? size,
    String colorName,
    int colorValue,
  ) {
    setState(() {
      _cartState.add(
        CartItem(
          productId: product.id,
          quantity: quantity,
          size: size,
          colorName: colorName,
          colorValue: colorValue,
        ),
      );
    });
  }

  void _openProduct(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailsScreen(
          product: product,
          isFavorite: _favoriteIds.contains(product.id),
          onToggleFavorite: _toggleFavorite,
          onAddToCart: _addSelectedToCart,
          onOpenCart: _openCart,
        ),
      ),
    );
  }

  void _openCart() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CartScreen(
          cartState: _cartState,
          onCartChanged: () {
            if (mounted) setState(() {});
          },
        ),
      ),
    );
  }

  void _showCategory(String categoryName) {
    setState(() {
      _selectedCategory = categoryName;
      _selectedIndex = 1;
    });
  }

  void _navigateFromProductList(int index) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(
              favoriteIds: _favoriteIds,
              onToggleFavorite: _toggleFavorite,
              onAddToCart: _addQuickToCart,
              onOpenProduct: _openProduct,
              onOpenCategory: _showCategory,
              onViewAllCategories: () => setState(() => _selectedIndex = 1),
              onOpenCart: _openCart,
            ),
            CategoriesScreen(
              selectedCategory: _selectedCategory,
              favoriteIds: _favoriteIds,
              onCategorySelected: (name) =>
                  setState(() => _selectedCategory = name),
              onToggleFavorite: _toggleFavorite,
              onAddToCart: _addQuickToCart,
              onOpenProduct: _openProduct,
              onOpenCart: _openCart,
              onNavigateTab: _navigateFromProductList,
            ),
            WishlistScreen(
              favoriteIds: _favoriteIds,
              onToggleFavorite: _toggleFavorite,
              onAddToCart: _addQuickToCart,
              onOpenProduct: _openProduct,
              onOpenCart: _openCart,
            ),
            AccountScreen(user: DummyData.user),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
