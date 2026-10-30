import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ZikrItemCard extends StatelessWidget {
  final String text;
  final int count;
  final int initialCount;
  final double fontSize;
  final String fontFamily;
  final Color categoryColor;
  final String? virtue;
  final int? itemIndex;
  final int? totalItems;
  final VoidCallback onTap;
  final VoidCallback? onReset;
  final VoidCallback? onCopy;

  const ZikrItemCard({
    super.key,
    required this.text,
    required this.count,
    required this.fontSize,
    required this.onTap,
    this.initialCount = 1,
    this.fontFamily = AppStrings.fontAmiri,
    this.categoryColor = AppColors.primary,
    this.virtue,
    this.itemIndex,
    this.totalItems,
    this.onReset,
    this.onCopy,
  });

  void _handleCopy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.selectionClick();
    if (onCopy != null) {
      onCopy!();
    } else {
      Get.rawSnackbar(
        messageText: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              "تم نسخ الذكر إلى الحافظة",
              style: TextStyle(
                fontFamily: AppStrings.fontCairo,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveInitialCount =
        initialCount > 0
            ? initialCount
            : (count > 0 ? count : 1);
    final isLastCount = count == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: categoryColor.withValues(alpha: 0.18),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withValues(alpha: 0.07),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header Bar of the Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.04),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: categoryColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Repetition Requirement Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: categoryColor.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          effectiveInitialCount > 1
                              ? Iconsax.repeat
                              : Icons.done_all_rounded,
                          size: 14,
                          color: categoryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          effectiveInitialCount > 1
                              ? "التكرار: $effectiveInitialCount مرات"
                              : "مرة واحدة",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppStrings.fontCairo,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Item Index Chip (if provided)
                  if (itemIndex != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        totalItems != null
                            ? "الذكر $itemIndex من $totalItems"
                            : "الذكر #$itemIndex",
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: AppStrings.fontCairo,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Quick Action Buttons (Copy & Reset)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Copy Button
                      IconButton(
                        tooltip: "نسخ الذكر",
                        icon: Icon(
                          Iconsax.copy,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: () => _handleCopy(context),
                      ),

                      // Reset Button (if provided)
                      if (onReset != null)
                        IconButton(
                          tooltip: "إعادة هذا الذكر",
                          icon: Icon(
                            Iconsax.refresh,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            onReset!();
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Zikr Text with High Legibility & Tashkeel Breathing Room
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              child: SelectableText(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: fontFamily,
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                  height: 1.85,
                  letterSpacing: 0.2,
                ),
              ),
            ),

            // Virtue or Reference Note (if available)
            if (virtue != null && virtue!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14)
                    .copyWith(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: categoryColor.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.star_1,
                          size: 13,
                          color: categoryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          virtue!,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: AppStrings.fontCairo,
                            color: Colors.grey.shade800,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Sleek & Comfortable Counter Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14)
                  .copyWith(bottom: 14),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (isLastCount) {
                      HapticFeedback.mediumImpact();
                    } else {
                      HapticFeedback.lightImpact();
                    }
                    onTap();
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          categoryColor,
                          categoryColor.withValues(alpha: 0.88),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left: Remaining Repetitions Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isLastCount
                                  ? "المرة الأخيرة!"
                                  : "متبقي: $count",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppStrings.fontCairo,
                              ),
                            ),
                          ),

                          // Center: Action Prompt
                          const Row(
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                color: Colors.white,
                                size: 17,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "اضغط للقراءة",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppStrings.fontCairo,
                                ),
                              ),
                            ],
                          ),

                          // Right: Circular Counter Badge
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "$count",
                              style: TextStyle(
                                color: categoryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppStrings.fontCairo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
