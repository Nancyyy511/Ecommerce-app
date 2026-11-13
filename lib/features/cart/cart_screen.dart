import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../data/product_repository.dart';
import '../../models/cart_item.dart';
import '../../models/cart_state.dart';
import '../../models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.cartState,
    required this.onCartChanged,
  });

  final CartState cartState;
  final VoidCallback onCartChanged;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _repository = const ProductRepository();

  double get _totalPrice {
    var total = 0.0;
    for (final item in widget.cartState.items) {
      final product = _repository.getProductById(item.productId);
      if (product != null) total += product.price * item.quantity;
    }
    return total;
  }

  void _refreshCart() {
    setState(() {});
    widget.onCartChanged();
  }

  void _checkout() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            widget.cartState.items.isEmpty
                ? 'Your cart is empty.'
                : 'Checkout is coming soon.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cartState.items;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text('Cart', style: AppTextStyles.header1),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.search, color: AppColors.primary, size: 27),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 52,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 12),
                  Text('Your cart is empty', style: AppTextStyles.header1),
                  SizedBox(height: 6),
                  Text(
                    'Add products to see them here.',
                    style: AppTextStyles.small,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                final product = _repository.getProductById(item.productId);
                if (product == null) return const SizedBox.shrink();
                return _CartItemCard(
                  item: item,
                  product: product,
                  onQuantityChanged: (quantity) {
                    widget.cartState.setQuantity(item.variantKey, quantity);
                    _refreshCart();
                  },
                  onRemove: () {
                    widget.cartState.remove(item.variantKey);
                    _refreshCart();
                  },
                );
              },
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
                      'EGP ${_totalPrice.toStringAsFixed(0)}',
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
                  child: FilledButton(
                    onPressed: _checkout,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Check Out'),
                        SizedBox(width: 24),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
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

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.product,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItem item;
  final Product product;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colorName = item.colorName ?? product.colorName;
    final colorValue = item.colorValue ?? product.colorValue;
    return Container(
      height: 113,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: double.infinity,
            child: product.imagePath == null
                ? const ColoredBox(
                    color: Color(0xFFF0F3F8),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 42,
                      color: AppColors.primary,
                    ),
                  )
                : Image.asset(product.imagePath!, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 7, 5),
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
                          style: AppTextStyles.header1.copyWith(fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                        height: 30,
                        child: IconButton(
                          onPressed: onRemove,
                          padding: EdgeInsets.zero,
                          tooltip: 'Remove ${product.name}',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.textPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Color(colorValue),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          '$colorName${item.size == null ? '' : ' | Size: ${item.size}'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.small.copyWith(
                            color: const Color(0xFF77719D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'EGP ${product.price.toStringAsFixed(0)}',
                          maxLines: 1,
                          style: AppTextStyles.general,
                        ),
                      ),
                      QuantityStepper(
                        quantity: item.quantity,
                        onChanged: onQuantityChanged,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
