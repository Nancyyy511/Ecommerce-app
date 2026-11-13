import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/favorite_button.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../models/product.dart';

typedef ProductDetailsAddToCart =
    void Function(
      Product product,
      int quantity,
      String? size,
      String colorName,
      int colorValue,
    );

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onOpenCart,
  });

  final Product product;
  final bool isFavorite;
  final ValueChanged<Product> onToggleFavorite;
  final ProductDetailsAddToCart onAddToCart;
  final VoidCallback onOpenCart;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  static const _sizes = ['38', '39', '40', '41', '42'];
  static const _commonColors = [
    _ColorOption('Black', Color(0xFF302C2C)),
    _ColorOption('Orange', Color(0xFFC33115)),
    _ColorOption('Blue', Color(0xFF0878E5)),
    _ColorOption('Green', Color(0xFF00B83F)),
    _ColorOption('Coral', Color(0xFFFF625C)),
  ];

  late bool _isFavorite;
  late String _selectedSize;
  late String _selectedColor;
  late int _selectedColorValue;
  int _quantity = 1;
  int _imageIndex = 0;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _selectedSize = _sizes[2];
    _selectedColor = widget.product.colorName;
    _selectedColorValue = widget.product.colorValue;
  }

  List<String> get _imagePaths {
    if (widget.product.galleryImagePaths.isNotEmpty) {
      return widget.product.galleryImagePaths;
    }
    final path = widget.product.imagePath;
    return path == null ? const [] : [path];
  }

  List<_ColorOption> get _colorOptions {
    final selected = _ColorOption(
      widget.product.colorName,
      Color(widget.product.colorValue),
    );
    final options = <_ColorOption>[selected];
    for (final option in _commonColors) {
      if (option.name != selected.name) options.add(option);
      if (options.length == 5) break;
    }
    return options;
  }

  void _changeQuantity(int quantity) {
    setState(() => _quantity = quantity < 1 ? 1 : quantity);
  }

  void _addToCart() {
    widget.onAddToCart(
      widget.product,
      _quantity,
      _selectedSize,
      _selectedColor,
      _selectedColorValue,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${widget.product.name} added to cart')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text('Product Details', style: AppTextStyles.header1),
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.search, color: AppColors.primary, size: 27),
          ),
          IconButton(
            onPressed: widget.onOpenCart,
            tooltip: 'Cart',
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.header1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'EGP ${product.price.toStringAsFixed(0)}',
                  style: AppTextStyles.header1,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFCFD8E6)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${product.soldCount} Sold',
                    style: AppTextStyles.small,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFC107),
                        size: 20,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.small,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                QuantityStepper(
                  quantity: _quantity,
                  onChanged: _changeQuantity,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Description', style: AppTextStyles.header1),
            const SizedBox(height: 6),
            Text(
              product.description,
              maxLines: _isDescriptionExpanded ? null : 2,
              overflow: _isDescriptionExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: AppTextStyles.small.copyWith(
                color: const Color(0xFF77719D),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(
                  () => _isDescriptionExpanded = !_isDescriptionExpanded,
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(_isDescriptionExpanded ? 'Read Less' : 'Read More'),
              ),
            ),
            const SizedBox(height: 4),
            const Text('Size', style: AppTextStyles.header1),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final size in _sizes)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _buildSizeOption(size),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Color', style: AppTextStyles.header1),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final option in _colorOptions)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildColorOption(option),
                  ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total price',
                      style: TextStyle(color: Color(0xFF77719D), fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'EGP ${(product.price * _quantity).toStringAsFixed(0)}',
                      style: AppTextStyles.general.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _addToCart,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to cart'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      textStyle: const TextStyle(fontSize: 16),
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

  Widget _buildImageCarousel() {
    final images = _imagePaths;
    return SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (images.isEmpty)
              const ColoredBox(
                color: Color(0xFFF0F3F8),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 84,
                  color: AppColors.primary,
                ),
              )
            else
              Semantics(
                label: 'Product image ${_imageIndex + 1} of ${images.length}',
                child: PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (index) => setState(() => _imageIndex = index),
                  itemBuilder: (context, index) =>
                      Image.asset(images[index], fit: BoxFit.cover),
                ),
              ),
            Positioned(
              top: 12,
              right: 12,
              child: FavoriteButton(
                isFavorite: _isFavorite,
                onPressed: () {
                  setState(() => _isFavorite = !_isFavorite);
                  widget.onToggleFavorite(widget.product);
                },
              ),
            ),
            if (images.length > 1)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var index = 0; index < images.length; index++)
                      AnimatedContainer(
                        key: ValueKey(
                          index == _imageIndex
                              ? 'selected-product-image-indicator-$index'
                              : 'product-image-indicator-$index',
                        ),
                        duration: const Duration(milliseconds: 180),
                        width: index == _imageIndex ? 28 : 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: index == _imageIndex
                              ? AppColors.primary
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    final selected = _selectedSize == size;
    return InkWell(
      onTap: () => setState(() => _selectedSize = size),
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Text(
          size,
          style: TextStyle(
            color: selected ? AppColors.white : AppColors.textPrimary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(_ColorOption option) {
    final selected = _selectedColor == option.name;
    return Tooltip(
      message: 'Select ${option.name} color',
      child: InkWell(
        onTap: () => setState(() {
          _selectedColor = option.name;
          _selectedColorValue = option.color.toARGB32();
        }),
        customBorder: const CircleBorder(),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: option.color,
            shape: BoxShape.circle,
            border: selected
                ? Border.all(color: AppColors.white, width: 2)
                : null,
          ),
          child: selected
              ? const Icon(Icons.check, color: AppColors.white, size: 21)
              : null,
        ),
      ),
    );
  }
}

class _ColorOption {
  const _ColorOption(this.name, this.color);

  final String name;
  final Color color;
}
