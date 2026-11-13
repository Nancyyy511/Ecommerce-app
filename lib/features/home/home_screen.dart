import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/main_header.dart';
import '../../core/widgets/product_card.dart';
import '../../data/product_repository.dart';
import '../../models/category.dart';
import '../../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onOpenProduct,
    required this.onOpenCategory,
    required this.onViewAllCategories,
    required this.onOpenCart,
  });

  final Set<String> favoriteIds;
  final ValueChanged<Product> onToggleFavorite;
  final ValueChanged<Product> onAddToCart;
  final ValueChanged<Product> onOpenProduct;
  final ValueChanged<String> onOpenCategory;
  final VoidCallback onViewAllCategories;
  final VoidCallback onOpenCart;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = const ProductRepository();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final products = _repository.getProducts();
    final applianceProducts = _repository.getProductsByCategory(
      'Home Appliance',
    );
    final categories = _repository.getCategories();
    final searchResults = _repository.searchProducts(_searchQuery);

    return Column(
      children: [
        MainHeader(
          onSearchChanged: (value) => setState(() => _searchQuery = value),
          onCartTap: widget.onOpenCart,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              if (_searchQuery.trim().isNotEmpty)
                _buildSearchResults(searchResults)
              else ...[
                _buildBannerCarousel(),
                const SizedBox(height: 18),
                _buildCategories(categories),
                const SizedBox(height: 16),
                _buildSectionTitle('Home Appliance'),
                _buildProductRail(applianceProducts),
                const SizedBox(height: 16),
                _buildFootwearBanner(products.first),
                const SizedBox(height: 18),
                _buildSectionTitle('New Arrival'),
                _buildProductRail(products.take(6).toList()),
                const SizedBox(height: 18),
                _buildSectionTitle('Smart Watch'),
                _buildProductRail(
                  products
                      .where(
                        (product) =>
                            product.name.toLowerCase().contains('watch'),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCarousel() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: AppAssets.homeBanners.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(AppAssets.homeBanners[index], fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(List<Category> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Expanded(
                child: Text('Categories', style: AppTextStyles.header1),
              ),
              TextButton(
                onPressed: widget.onViewAllCategories,
                child: const Text(
                  'view all',
                  style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
        for (var row = 0; row < 2; row++)
          SizedBox(
            height: 158,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final categoryIndex = row * 4 + index;
                if (categoryIndex >= categories.length) {
                  return const SizedBox.shrink();
                }
                final category = categories[categoryIndex];
                return SizedBox(
                  width: 100,
                  child: InkWell(
                    onTap: () => widget.onOpenCategory(category.name),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            category.imagePath,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.25,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Text(title, style: AppTextStyles.header1),
    );
  }

  Widget _buildFootwearBanner(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => widget.onOpenProduct(product),
          child: SizedBox(
            height: 112,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Footwear',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => widget.onOpenProduct(product),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            backgroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            minimumSize: const Size(0, 32),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          child: const Text('Shop Now'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: double.infinity,
                  child: Image.asset(product.imagePath!, fit: BoxFit.cover),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductRail(List<Product> products) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Text('No products available yet.', style: AppTextStyles.small),
      );
    }

    return SizedBox(
      height: 205,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 160,
            child: ProductCard(
              compact: true,
              product: product,
              isFavorite: widget.favoriteIds.contains(product.id),
              onFavoriteTap: () => widget.onToggleFavorite(product),
              onAddTap: () => widget.onAddToCart(product),
              onTap: () => widget.onOpenProduct(product),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(List<Product> results) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Results (${results.length})',
            style: AppTextStyles.header1,
          ),
          const SizedBox(height: 12),
          if (results.isEmpty)
            const Text(
              'No matching products found.',
              style: AppTextStyles.general,
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: 237,
              ),
              itemBuilder: (context, index) => _productCard(results[index]),
            ),
        ],
      ),
    );
  }

  Widget _productCard(Product product) {
    return ProductCard(
      product: product,
      isFavorite: widget.favoriteIds.contains(product.id),
      onFavoriteTap: () => widget.onToggleFavorite(product),
      onAddTap: () => widget.onAddToCart(product),
      onTap: () => widget.onOpenProduct(product),
    );
  }
}
