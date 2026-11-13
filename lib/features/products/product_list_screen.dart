import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_route_observer.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/main_header.dart';
import '../../core/widgets/product_card.dart';
import '../../data/product_repository.dart';
import '../layout/widgets/custom_bottom_nav_bar.dart';
import '../../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({
    super.key,
    required this.categoryName,
    required this.subcategory,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onOpenProduct,
    required this.onOpenCart,
    required this.onNavigateTab,
  });

  final String categoryName;
  final String? subcategory;
  final Set<String> favoriteIds;
  final ValueChanged<Product> onToggleFavorite;
  final ValueChanged<Product> onAddToCart;
  final ValueChanged<Product> onOpenProduct;
  final VoidCallback onOpenCart;
  final ValueChanged<int> onNavigateTab;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> with RouteAware {
  final _repository = const ProductRepository();
  ModalRoute<dynamic>? _subscribedRoute;
  String _searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route != _subscribedRoute) {
      if (_subscribedRoute != null) {
        appRouteObserver.unsubscribe(this);
      }
      appRouteObserver.subscribe(this, route);
      _subscribedRoute = route;
    }
  }

  @override
  void didPopNext() {
    setState(() {});
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  List<Product> get _visibleProducts {
    return _repository.searchProducts(
      _searchQuery,
      category: widget.categoryName,
      subcategory: widget.subcategory,
    );
  }

  void _toggleFavorite(Product product) {
    widget.onToggleFavorite(product);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            MainHeader(
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              onCartTap: widget.onOpenCart,
            ),
            if (widget.subcategory != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.subcategory!,
                    style: AppTextStyles.header1,
                  ),
                ),
              ),
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Text(
                        _searchQuery.isNotEmpty
                            ? 'No matching products found.'
                            : 'No products available in this category yet.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.general,
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            mainAxisExtent: 237,
                          ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          isFavorite: widget.favoriteIds.contains(product.id),
                          onFavoriteTap: () => _toggleFavorite(product),
                          onAddTap: () => widget.onAddToCart(product),
                          onTap: () => widget.onOpenProduct(product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1,
        onSelected: widget.onNavigateTab,
      ),
    );
  }
}
