import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../../models/product.dart';
import 'favorite_button.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onAddTap,
    required this.onTap,
    this.compact = false,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddTap;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cardHeight = compact ? 205.0 : 237.0;
    final imageHeight = compact ? 104.0 : 126.0;

    return SizedBox(
      height: cardHeight,
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (product.imagePath != null)
                        Image.asset(product.imagePath!, fit: BoxFit.cover)
                      else
                        ColoredBox(
                          color: const Color(0xFFF0F3F8),
                          child: Icon(
                            _iconForSubcategory(product.subcategory),
                            size: 54,
                            color: AppColors.primary,
                          ),
                        ),
                      Positioned(
                        top: 7,
                        right: 7,
                        child: FavoriteButton(
                          isFavorite: isFavorite,
                          onPressed: onFavoriteTap,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.3,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'EGP ${product.price.toStringAsFixed(0)}',
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
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
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Review (${product.rating.toStringAsFixed(1)})',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Color(0xFFFFC107),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: Material(
                                color: AppColors.primary,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  onTap: onAddTap,
                                  customBorder: const CircleBorder(),
                                  child: const Icon(
                                    Icons.add,
                                    color: AppColors.white,
                                    size: 22,
                                  ),
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

  IconData _iconForSubcategory(String subcategory) {
    return switch (subcategory) {
      'Washing Machines' => Icons.local_laundry_service_outlined,
      'Cooktops' => Icons.local_fire_department_outlined,
      'Irons' => Icons.iron_outlined,
      _ => Icons.inventory_2_outlined,
    };
  }
}
