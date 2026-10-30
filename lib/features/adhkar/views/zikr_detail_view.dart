import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/adhkar_controller.dart';
import '../models/zikr_category.dart';
import '../widgets/zikr_finished_summary.dart';
import '../widgets/zikr_item_card.dart';

class ZikrDetailView extends GetView<AdhkarController> {
  const ZikrDetailView({super.key});

  String _getTitle(ZikrCategoryType type) {
    switch (type) {
      case ZikrCategoryType.sabh:
        return AppStrings.sabhTitle;
      case ZikrCategoryType.masi:
        return AppStrings.masiTitle;
      case ZikrCategoryType.sleep:
        return AppStrings.sleepTitle;
      case ZikrCategoryType.safer:
        return AppStrings.saferTitle;
      case ZikrCategoryType.alham:
        return AppStrings.alhamTitle;
      case ZikrCategoryType.tasbeeh:
        return AppStrings.tasbeehTitle;
    }
  }

  Color _getCategoryColor(ZikrCategoryType type) {
    switch (type) {
      case ZikrCategoryType.sabh:
        return AppColors.sabhColor;
      case ZikrCategoryType.masi:
        return AppColors.masiColor;
      case ZikrCategoryType.sleep:
        return AppColors.sleepColor;
      case ZikrCategoryType.safer:
        return AppColors.saferColor;
      case ZikrCategoryType.alham:
        return AppColors.alhamColor;
      case ZikrCategoryType.tasbeeh:
        return AppColors.tasbeehColor;
    }
  }

  IconData _getCategoryIcon(ZikrCategoryType type) {
    switch (type) {
      case ZikrCategoryType.sabh:
        return Icons.wb_sunny_rounded;
      case ZikrCategoryType.masi:
        return Icons.nightlight_round;
      case ZikrCategoryType.sleep:
        return Icons.bedtime_rounded;
      case ZikrCategoryType.safer:
        return Icons.airplanemode_active_rounded;
      case ZikrCategoryType.alham:
        return Icons.favorite_rounded;
      case ZikrCategoryType.tasbeeh:
        return Iconsax.repeat_circle;
    }
  }

  void _showFontSettings(BuildContext context, Color categoryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Obx(() {
          final currentSize = controller.textFont.value.toDouble();
          final currentFamily = controller.selectedFontFamily.value;

          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Sheet Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "تخصيص الخط والقراءة",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppStrings.fontCairo,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Font Family Selector
                const Text(
                  "نوع الخط العربي:",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppStrings.fontCairo,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Amiri Font Option
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            controller.setFontFamily(AppStrings.fontAmiri),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: currentFamily == AppStrings.fontAmiri
                                ? categoryColor.withValues(alpha: 0.12)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: currentFamily == AppStrings.fontAmiri
                                  ? categoryColor
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "خط أميري (نسخ قرآني)",
                            style: TextStyle(
                              fontFamily: AppStrings.fontAmiri,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: currentFamily == AppStrings.fontAmiri
                                  ? categoryColor
                                  : Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Cairo Font Option
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            controller.setFontFamily(AppStrings.fontCairo),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: currentFamily == AppStrings.fontCairo
                                ? categoryColor.withValues(alpha: 0.12)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: currentFamily == AppStrings.fontCairo
                                  ? categoryColor
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "خط كايرو (عصري)",
                            style: TextStyle(
                              fontFamily: AppStrings.fontCairo,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: currentFamily == AppStrings.fontCairo
                                  ? categoryColor
                                  : Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Font Size Controls & Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "حجم الخط:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppStrings.fontCairo,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      "${currentSize.toInt()} نقطة",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppStrings.fontCairo,
                        color: categoryColor,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                      color: categoryColor,
                      onPressed: controller.decreaseFontSize,
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(ctx).copyWith(
                          activeTrackColor: categoryColor,
                          inactiveTrackColor:
                              categoryColor.withValues(alpha: 0.2),
                          thumbColor: categoryColor,
                          overlayColor:
                              categoryColor.withValues(alpha: 0.15),
                        ),
                        child: Slider(
                          value: currentSize,
                          min: 18,
                          max: 40,
                          divisions: 11,
                          onChanged: (val) => controller.setFontSize(val),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      color: categoryColor,
                      onPressed: controller.increaseFontSize,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Preview Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF8F2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ • لا إلهَ إلاّ اللهُ",
                    style: TextStyle(
                      fontFamily: currentFamily,
                      fontSize: currentSize,
                      color: const Color(0xFF1E293B),
                      height: 1.7,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categoryType = controller.currentCategoryType.value;
      final title = _getTitle(categoryType);
      final categoryColor = _getCategoryColor(categoryType);
      final categoryIcon = _getCategoryIcon(categoryType);
      final isFinished = controller.isFinished;
      final textFont = controller.textFont.value.toDouble();
      final fontFamily = controller.selectedFontFamily.value;

      return Scaffold(
        backgroundColor: const Color(0xFFFBF8F2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFF1E293B),
            ),
            onPressed: () => Get.back(),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(categoryIcon, color: categoryColor, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: AppStrings.fontCairo,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          actions: [
            // Quick Font Resize A-
            IconButton(
              tooltip: "تصغير الخط",
              icon: const Text(
                "A-",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: AppStrings.fontCairo,
                  color: Color(0xFF475569),
                ),
              ),
              onPressed: controller.decreaseFontSize,
            ),

            // Quick Font Resize A+
            IconButton(
              tooltip: "تكبير الخط",
              icon: const Text(
                "A+",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  fontFamily: AppStrings.fontCairo,
                  color: Color(0xFF475569),
                ),
              ),
              onPressed: controller.increaseFontSize,
            ),

            // Font Settings Sheet Button
            IconButton(
              tooltip: "خيارات الخط",
              icon: const Icon(
                Iconsax.text_block,
                size: 20,
                color: Color(0xFF1E293B),
              ),
              onPressed: () => _showFontSettings(context, categoryColor),
            ),

            // Restart Category Button
            IconButton(
              tooltip: "إعادة البدء",
              icon: const Icon(
                Iconsax.refresh,
                size: 20,
                color: Color(0xFF1E293B),
              ),
              onPressed: () {
                controller.restartCategory();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Progress Bar Header (Visible when reading)
              if (!isFinished && controller.initialCategoryCount.value > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: categoryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "متبقي: ${controller.azkarList.length} ذكر",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppStrings.fontCairo,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "أكملت ${controller.completedCount} من ${controller.initialCategoryCount.value}",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: AppStrings.fontCairo,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: controller.progress,
                          minHeight: 6,
                          backgroundColor:
                              categoryColor.withValues(alpha: 0.12),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            categoryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Active Zikr Cards or Finished Summary
              Expanded(
                child: isFinished
                    ? ZikrFinishedSummary(
                        currentReadCount: controller.currentReadCount.value,
                        totalReadCount: controller.totalReadCount.value,
                        onBack: () => Get.back(),
                        onRestart: () => controller.restartCategory(),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: controller.azkarList.length,
                        itemBuilder: (context, index) {
                          final item = controller.azkarList[index];
                          return ZikrItemCard(
                            text: item.text,
                            count: item.count,
                            initialCount: item.initialCount,
                            fontSize: textFont,
                            fontFamily: fontFamily,
                            categoryColor: categoryColor,
                            virtue: item.virtue,
                            itemIndex: index + 1,
                            totalItems: controller.azkarList.length,
                            onTap: () => controller.onTapItem(index),
                            onReset: () => controller.resetItem(index),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
