import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const String fontFamily = 'Poppins';
  static const double letterSpacing = -0.165;

  static const TextStyle header1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: letterSpacing,
    color: AppColors.textPrimary,
  );

  static const TextStyle general = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 18 / 14,
    letterSpacing: letterSpacing,
    color: AppColors.textPrimary,
  );

  static const TextStyle small = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    letterSpacing: letterSpacing,
    color: AppColors.textPrimary,
  );

  static const TextStyle oldPrice = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 18 / 11,
    letterSpacing: letterSpacing,
    color: AppColors.textPrimary,
    decoration: TextDecoration.lineThrough,
  );
}
