import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.grid_view_rounded, label: 'Categories'),
    (icon: Icons.favorite_border_rounded, label: 'Wishlist'),
    (icon: Icons.person_outline_rounded, label: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      height: 56 + bottomInset,
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          for (var index = 0; index < _items.length; index++)
            Expanded(
              child: Semantics(
                button: true,
                selected: index == selectedIndex,
                label: _items[index].label,
                child: InkWell(
                  onTap: () => onSelected(index),
                  borderRadius: BorderRadius.circular(28),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: index == selectedIndex ? AppColors.white : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _items[index].icon,
                        size: 24,
                        color: index == selectedIndex ? AppColors.primary : AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
