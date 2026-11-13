import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/favorite_button.dart';
import '../../core/widgets/main_header.dart';
import '../../data/product_repository.dart';
import '../../models/product.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onOpenProduct,
    required this.onOpenCart,
  });

  final Set<String> favoriteIds;
  final ValueChanged<Product> onToggleFavorite;
  final ValueChanged<Product> onAddToCart;
  final ValueChanged<Product> onOpenProduct;
  final VoidCallback onOpenCart;

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final _repository = const ProductRepository();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProducts = _repository
        .getProducts()
        .where((product) => widget.favoriteIds.contains(product.id))
        .toList();
    final products = _repository
        .searchProducts(_searchQuery)
        .where((product) => widget.favoriteIds.contains(product.id))
        .toList();

    return Column(
      children: [
        MainHeader(
          searchController: _searchController,
          onSearchChanged: (value) => setState(() => _searchQuery = value),
          onCartTap: widget.onOpenCart,
        ),
        Expanded(
          child: favoriteProducts.isEmpty
              ? _buildEmptyState()
              : products.isEmpty
              ? _buildNoResultsState()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                  itemCount: products.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 22),
                  itemBuilder: (context, index) => _WishlistProductCard(
                    product: products[index],
                    onTap: () => widget.onOpenProduct(products[index]),
                    onFavoriteTap: () {
                      widget.onToggleFavorite(products[index]);
                      setState(() {});
                    },
                    onAddTap: () => widget.onAddToCart(products[index]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('No products found', style: AppTextStyles.header1),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
            child: const Text('Clear search'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border_rounded,
              size: 58,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text('Your wishlist is empty', style: AppTextStyles.header1),
            const SizedBox(height: 8),
            Text(
              'Save products you like and find them here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.general.copyWith(
                color: const Color(0xFF77719D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishlistProductCard extends StatelessWidget {
  const _WishlistProductCard({
    required this.product,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onAddTap,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                SizedBox(
                  width: 119,
                  height: double.infinity,
                  child: product.imagePath == null
                      ? const ColoredBox(
                          color: Color(0xFFF0F3F8),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.primary,
                          ),
                        )
                      : Image.asset(product.imagePath!, fit: BoxFit.cover),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.header1.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            FavoriteButton(
                              isFavorite: true,
                              onPressed: onFavoriteTap,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Color(product.colorValue),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                '${product.colorName} color',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.general,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'EGP ${product.price.toStringAsFixed(0)}',
                                maxLines: 1,
                                style: AppTextStyles.header1.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (product.oldPrice != null) ...[
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  'EGP ${product.oldPrice!.toStringAsFixed(0)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.oldPrice.copyWith(
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            SizedBox(
                              height: 36,
                              child: FilledButton(
                                onPressed: onAddTap,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  'Add to Cart',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
