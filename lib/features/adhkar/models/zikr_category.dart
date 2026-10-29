import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

enum ZikrCategoryType { sabh, masi, sleep, safer, alham, tasbeeh }

class ZikrCategory {
  final ZikrCategoryType type;
  final String title;
  final IconData icon;
  final Color color;

  const ZikrCategory({
    required this.type,
    required this.title,
    required this.icon,
    required this.color,
  });

  static const List<ZikrCategory> categories = [
    ZikrCategory(
      type: ZikrCategoryType.masi,
      title: AppStrings.masiTitle,
      icon: Icons.nightlight_round,
      color: AppColors.masiColor,
    ),
    ZikrCategory(
      type: ZikrCategoryType.sabh,
      title: AppStrings.sabhTitle,
      icon: Icons.wb_sunny,
      color: AppColors.sabhColor,
    ),
    ZikrCategory(
      type: ZikrCategoryType.sleep,
      title: AppStrings.sleepTitle,
      icon: Icons.bedtime,
      color: AppColors.sleepColor,
    ),
    ZikrCategory(
      type: ZikrCategoryType.safer,
      title: AppStrings.saferTitle,
      icon: Icons.airplanemode_active,
      color: AppColors.saferColor,
    ),
    ZikrCategory(
      type: ZikrCategoryType.alham,
      title: AppStrings.alhamTitle,
      icon: Icons.sentiment_dissatisfied,
      color: AppColors.alhamColor,
    ),
    ZikrCategory(
      type: ZikrCategoryType.tasbeeh,
      title: AppStrings.tasbeehCategoryTitle,
      icon: Iconsax.repeat_circle,
      color: AppColors.tasbeehColor,
    ),
  ];
}
