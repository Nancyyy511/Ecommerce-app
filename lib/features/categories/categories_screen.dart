import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/main_header.dart';
import '../../data/product_repository.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../products/product_list_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.selectedCategory,
    required this.favoriteIds,
    required this.onCategorySelected,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onOpenProduct,
    required this.onOpenCart,
    required this.onNavigateTab,
  });

  final String selectedCategory;
  final Set<String> favoriteIds;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<Product> onToggleFavorite;
  final ValueChanged<Product> onAddToCart;
  final ValueChanged<Product> onOpenProduct;
  final VoidCallback onOpenCart;
  final ValueChanged<int> onNavigateTab;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _repository = const ProductRepository();
  String _searchQuery = '';
  static const _sidebarOrder = [
    "Men's Fashion",
    "Women's Fashion",
    'Skincare',
    'Beauty',
    'Headphones',
    'Cameras',
    'Laptops & Electronics',
    'Baby & Toys',
  ];

  @override
  Widget build(BuildContext context) {
    final categories = _repository.getCategories().toList();
    categories.sort((first, second) {
      final firstPosition = _sidebarOrder.indexOf(first.name);
      final secondPosition = _sidebarOrder.indexOf(second.name);
      return (firstPosition < 0 ? _sidebarOrder.length : firstPosition)
          .compareTo(
            secondPosition < 0 ? _sidebarOrder.length : secondPosition,
          );
    });
    final selected = categories.firstWhere(
      (category) => category.name == widget.selectedCategory,
      orElse: () => categories.first,
    );

    return Column(
      children: [
        MainHeader(
          onSearchChanged: (value) => setState(() => _searchQuery = value),
          onCartTap: widget.onOpenCart,
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 390;
              final sidebarWidth = constraints.maxWidth < 350
                  ? 90.0
                  : isNarrow
                  ? 112.0
                  : 137.0;
              final columnGap = isNarrow ? 12.0 : 24.0;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: sidebarWidth,
                      child: ColoredBox(
                        color: const Color(0xFFF0F3F8),
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) => _CategorySidebarItem(
                            category: categories[index],
                            selected: categories[index].name == selected.name,
                            onTap: () => widget.onCategorySelected(
                              categories[index].name,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: columnGap),
                    Expanded(
                      child: _CategoryContent(
                        category: selected,
                        searchQuery: _searchQuery,
                        favoriteIds: widget.favoriteIds,
                        onToggleFavorite: widget.onToggleFavorite,
                        onAddToCart: widget.onAddToCart,
                        onOpenProduct: widget.onOpenProduct,
                        onOpenCart: widget.onOpenCart,
                        onNavigateTab: widget.onNavigateTab,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategorySidebarItem extends StatelessWidget {
  const _CategorySidebarItem({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final Category category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.white : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 82,
          child: Row(
            children: [
              Container(
                width: 6,
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryContent extends StatelessWidget {
  const _CategoryContent({
    required this.category,
    required this.searchQuery,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onOpenProduct,
    required this.onOpenCart,
    required this.onNavigateTab,
  });

  final Category category;
  final String searchQuery;
  final Set<String> favoriteIds;
  final ValueChanged<Product> onToggleFavorite;
  final ValueChanged<Product> onAddToCart;
  final ValueChanged<Product> onOpenProduct;
  final VoidCallback onOpenCart;
  final ValueChanged<int> onNavigateTab;

  bool get _isWomen => category.name == "Women's Fashion";
  bool get _isMen => category.name == "Men's Fashion";

  @override
  Widget build(BuildContext context) {
    final imagePaths = _isWomen ? AppAssets.women : AppAssets.men;
    final bannerPath = _isWomen
        ? AppAssets.womenBanner
        : _isMen
        ? AppAssets.menBanner
        : category.imagePath;
    final subcategories = category.subcategories
        .where(
          (name) =>
              name.toLowerCase().contains(searchQuery.trim().toLowerCase()),
        )
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = constraints.maxWidth < 200 ? 2 : 3;
        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 2, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 94,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(bannerPath, fit: BoxFit.cover),
                      ColoredBox(color: Colors.black.withValues(alpha: 0.15)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                height: 1.15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 32,
                              child: FilledButton(
                                onPressed: () =>
                                    _openProductList(context, null),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: const Text('Shop Now'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (subcategories.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    category.subcategories.isEmpty
                        ? 'No subcategories available.'
                        : 'No matching subcategories.',
                    style: AppTextStyles.small,
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subcategories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                    childAspectRatio: columnCount == 2 ? 0.82 : 0.72,
                  ),
                  itemBuilder: (context, index) => _SubcategoryItem(
                    name: subcategories[index],
                    imagePath: imagePaths[index % imagePaths.length],
                    onTap: () =>
                        _openProductList(context, subcategories[index]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _openProductList(BuildContext context, String? subcategory) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductListScreen(
          categoryName: category.name,
          subcategory: subcategory,
          favoriteIds: favoriteIds,
          onToggleFavorite: onToggleFavorite,
          onAddToCart: onAddToCart,
          onOpenProduct: onOpenProduct,
          onOpenCart: onOpenCart,
          onNavigateTab: onNavigateTab,
        ),
      ),
    );
  }
}

class _SubcategoryItem extends StatelessWidget {
  const _SubcategoryItem({
    required this.name,
    required this.imagePath,
    required this.onTap,
  });

  final String name;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: SizedBox.expand(
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
