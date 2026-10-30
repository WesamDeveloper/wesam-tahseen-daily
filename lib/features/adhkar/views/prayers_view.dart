import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../data/adhkar_data.dart';
import '../models/zikr_category.dart';
import '../widgets/islamic_card.dart';

class PrayersView extends StatefulWidget {
  const PrayersView({super.key});

  @override
  State<PrayersView> createState() => _PrayersViewState();
}

class _PrayersViewState extends State<PrayersView> {
  int _totalReadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalRead();
  }

  void _loadTotalRead() {
    if (Get.isRegistered<StorageService>()) {
      setState(() {
        _totalReadCount = Get.find<StorageService>().getTotalReadCount();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sabhCount =
        AdhkarData.getItemsByCategory(ZikrCategoryType.sabh).length;
    final masiCount =
        AdhkarData.getItemsByCategory(ZikrCategoryType.masi).length;
    final sleepCount =
        AdhkarData.getItemsByCategory(ZikrCategoryType.sleep).length;
    final saferCount =
        AdhkarData.getItemsByCategory(ZikrCategoryType.safer).length;
    final alhamCount =
        AdhkarData.getItemsByCategory(ZikrCategoryType.alham).length;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F2),
      appBar: AppBar(
        title: const Text(
          AppStrings.prayersTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppStrings.fontCairo,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadTotalRead();
          },
          color: AppColors.primary,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ).copyWith(bottom: 24),
            children: [
              // Inspirational Islamic Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFF7ED),
                      Color(0xFFFEF3C7),
                      Color(0xFFFFFBEB),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.22),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      AppStrings.bismillah,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: AppStrings.fontAmiri,
                        color: Color(0xFF78350F),
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            "﴿ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: AppStrings.fontAmiri,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF92400E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1),
                          Text(
                            "سورة الرعد • آية ٢٨",
                            style: TextStyle(
                              fontSize: 10.5,
                              fontFamily: AppStrings.fontCairo,
                              color: Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_totalReadCount > 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Iconsax.award,
                              size: 13,
                              color: Color(0xFF059669),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "إجمالي أذكارك المحفوظة: $_totalReadCount ذكراً",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppStrings.fontCairo,
                                color: Color(0xFF065F46),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Section: Daily Core Adhkar (Morning & Evening Side-by-Side)
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "الورد اليومي (الصباح والمساء)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppStrings.fontCairo,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Hero Duo: Morning & Evening Cards
              Row(
                children: [
                  // Morning Adhkar Card
                  Expanded(
                    child: HeroZikrCard(
                      title: AppStrings.sabhTitle,
                      icon: Icons.wb_sunny_rounded,
                      primaryColor: const Color(0xFFE65100),
                      gradientColors: const [
                        Color(0xFFFFF7ED),
                        Color(0xFFFFEDD5),
                      ],
                      borderColor: const Color(0xFFFED7AA),
                      countText: "$sabhCount ذكر",
                      onTap: () async {
                        await Get.toNamed(
                          AppRoutes.zikrDetail,
                          arguments: ZikrCategoryType.sabh,
                        );
                        _loadTotalRead();
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Evening Adhkar Card
                  Expanded(
                    child: HeroZikrCard(
                      title: AppStrings.masiTitle,
                      icon: Icons.nightlight_round,
                      primaryColor: const Color(0xFF3949AB),
                      gradientColors: const [
                        Color(0xFFEEF2FF),
                        Color(0xFFE0E7FF),
                      ],
                      borderColor: const Color(0xFFC7D2FE),
                      countText: "$masiCount ذكر",
                      onTap: () async {
                        await Get.toNamed(
                          AppRoutes.zikrDetail,
                          arguments: ZikrCategoryType.masi,
                        );
                        _loadTotalRead();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Section Header: Other Chapters
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "أبواب الذكر والتحصين",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppStrings.fontCairo,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 2x2 Grid of Secondary Categories (Spacious, uncrowded, clean)
              // Row 1: Sleep + Travel
              Row(
                children: [
                  Expanded(
                    child: GridZikrCard(
                      title: AppStrings.sleepTitle,
                      icon: Icons.bedtime_rounded,
                      color: const Color(0xFF7C3AED),
                      backgroundColor: const Color(0xFFFAF5FF),
                      borderColor: const Color(0xFFE9D5FF),
                      countText: "$sleepCount أذكار",
                      onTap: () async {
                        await Get.toNamed(
                          AppRoutes.zikrDetail,
                          arguments: ZikrCategoryType.sleep,
                        );
                        _loadTotalRead();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GridZikrCard(
                      title: AppStrings.saferTitle,
                      icon: Icons.airplanemode_active_rounded,
                      color: const Color(0xFF0D9488),
                      backgroundColor: const Color(0xFFF0FDFA),
                      borderColor: const Color(0xFF99F6E4),
                      countText: "$saferCount أذكار",
                      onTap: () async {
                        await Get.toNamed(
                          AppRoutes.zikrDetail,
                          arguments: ZikrCategoryType.safer,
                        );
                        _loadTotalRead();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Row 2: Relief + Tasbeeh
              Row(
                children: [
                  Expanded(
                    child: GridZikrCard(
                      title: AppStrings.alhamTitle,
                      icon: Icons.favorite_rounded,
                      color: const Color(0xFFE11D48),
                      backgroundColor: const Color(0xFFFFF1F2),
                      borderColor: const Color(0xFFFECDD3),
                      countText: "$alhamCount أذكار",
                      onTap: () async {
                        await Get.toNamed(
                          AppRoutes.zikrDetail,
                          arguments: ZikrCategoryType.alham,
                        );
                        _loadTotalRead();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GridZikrCard(
                      title: AppStrings.tasbeehCategoryTitle,
                      icon: Iconsax.repeat_circle,
                      color: const Color(0xFF059669),
                      backgroundColor: const Color(0xFFECFDF5),
                      borderColor: const Color(0xFFA7F3D0),
                      countText: "مسبحة ذكية",
                      onTap: () async {
                        await Get.toNamed(AppRoutes.tasbeeh);
                        _loadTotalRead();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Pious Footer Dua
              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      size: 13,
                      color: Color(0xFFCBD5E1),
                    ),
                    SizedBox(width: 6),
                    Text(
                      AppStrings.duaFooter,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppStrings.fontCairo,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
