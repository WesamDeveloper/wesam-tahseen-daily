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
  final String subtitle;
  final String badge;
  final List<Color> gradient;

  const ZikrCategory({
    required this.type,
    required this.title,
    required this.icon,
    required this.color,
    this.subtitle = '',
    this.badge = '',
    this.gradient = const [],
  });

  static const List<ZikrCategory> categories = [
    ZikrCategory(
      type: ZikrCategoryType.sabh,
      title: AppStrings.sabhTitle,
      icon: Icons.wb_sunny_rounded,
      color: AppColors.sabhColor,
      subtitle: 'حصنك اليومي لنور الصباح والبركة والسكينة',
      badge: 'صباحي',
      gradient: [Color(0xFFFFA726), Color(0xFFFB8C00)],
    ),
    ZikrCategory(
      type: ZikrCategoryType.masi,
      title: AppStrings.masiTitle,
      icon: Icons.nightlight_round,
      color: AppColors.masiColor,
      subtitle: 'سكينة المساء وحفظ من كل مكروه وسوء',
      badge: 'مسائي',
      gradient: [Color(0xFF3949AB), Color(0xFF1A237E)],
    ),
    ZikrCategory(
      type: ZikrCategoryType.sleep,
      title: AppStrings.sleepTitle,
      icon: Icons.bedtime_rounded,
      color: AppColors.sleepColor,
      subtitle: 'طمأنينة وهدوء النفس وحفظ قبل المنام',
      badge: 'ليلي',
      gradient: [Color(0xFF7E57C2), Color(0xFF512DA8)],
    ),
    ZikrCategory(
      type: ZikrCategoryType.safer,
      title: AppStrings.saferTitle,
      icon: Icons.airplanemode_active_rounded,
      color: AppColors.saferColor,
      subtitle: 'حفظ الله ورعايته في حلك وترحالك',
      badge: 'سفر',
      gradient: [Color(0xFF00897B), Color(0xFF004D40)],
    ),
    ZikrCategory(
      type: ZikrCategoryType.alham,
      title: AppStrings.alhamTitle,
      icon: Icons.favorite_rounded,
      color: AppColors.alhamColor,
      subtitle: 'انشراح الصدر وتفريج الكروب والهموم',
      badge: 'تفريج',
      gradient: [Color(0xFFE53935), Color(0xFFB71C1C)],
    ),
    ZikrCategory(
      type: ZikrCategoryType.tasbeeh,
      title: AppStrings.tasbeehCategoryTitle,
      icon: Iconsax.repeat_circle,
      color: AppColors.tasbeehColor,
      subtitle: 'سَبّح واستغفر واذكر ربك في كل حين',
      badge: 'مسبحة',
      gradient: [Color(0xFF43A047), Color(0xFF1B5E20)],
    ),
  ];
}
