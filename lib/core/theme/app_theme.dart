import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          surface: AppColors.white,
          onSurface: AppColors.textPrimary,
        ),
        fontFamily: AppTextStyles.fontFamily,
        textTheme: const TextTheme(
          bodyLarge: AppTextStyles.general,
          bodyMedium: AppTextStyles.general,
          bodySmall: AppTextStyles.small,
          titleLarge: AppTextStyles.header1,
        ),
      );
}
