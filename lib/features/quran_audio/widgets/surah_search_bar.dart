import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/quran_audio_controller.dart';

class SurahSearchBar extends GetView<QuranAudioController> {
  const SurahSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.filterSurahs,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: AppStrings.searchSurahHint,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontFamily: AppStrings.fontCairo,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primaryDeep,
          ),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear_rounded, size: 20),
                color: AppColors.grey,
                onPressed: controller.clearSearch,
              );
            }
            return const SizedBox.shrink();
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
