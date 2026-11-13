import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: IconButton(
        onPressed: onPressed,
        tooltip: isFavorite ? 'Remove from wishlist' : 'Add to wishlist',
        constraints: const BoxConstraints.tightFor(width: 34, height: 34),
        padding: EdgeInsets.zero,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 21,
          color: isFavorite ? AppColors.primary : AppColors.primary,
        ),
      ),
    );
  }
}
