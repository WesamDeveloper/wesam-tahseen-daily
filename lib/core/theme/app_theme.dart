import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        surface: AppColors.white,
      ),
      fontFamily: AppStrings.fontCairo,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: AppStrings.fontRakkas,
          fontSize: 28,
          color: AppColors.black,
        ),
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
