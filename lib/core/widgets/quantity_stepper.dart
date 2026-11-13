import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 122,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            label: 'Decrease quantity',
            onPressed: () => onChanged(quantity - 1),
          ),
          Text(
            '$quantity',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            label: 'Increase quantity',
            onPressed: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 29,
      height: 29,
      child: IconButton(
        onPressed: onPressed,
        tooltip: label,
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: AppColors.white, size: 24),
      ),
    );
  }
}
