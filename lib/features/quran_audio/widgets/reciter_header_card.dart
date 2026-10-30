import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/quran_audio_controller.dart';

class ReciterHeaderCard extends GetView<QuranAudioController> {
  const ReciterHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Obx(() {
        final surah = controller.currentSurah.value;
        final isPlaying = controller.isPlaying.value;
        final isLoading = controller.isLoading.value;
        final hasError = controller.hasError.value;

        String statusText;
        Color statusColor;
        IconData statusIcon;

        if (hasError) {
          statusText = AppStrings.audioError;
          statusColor = Colors.red;
          statusIcon = Icons.error_outline_rounded;
        } else if (isLoading) {
          statusText = AppStrings.buffering;
          statusColor = AppColors.primaryDark;
          statusIcon = Icons.hourglass_top_rounded;
        } else if (isPlaying) {
          statusText = AppStrings.nowPlaying;
          statusColor = Colors.green.shade700;
          statusIcon = Icons.graphic_eq_rounded;
        } else if (controller.position.value > Duration.zero) {
          statusText = AppStrings.paused;
          statusColor = Colors.amber.shade800;
          statusIcon = Icons.pause_circle_outline_rounded;
        } else {
          statusText = AppStrings.readyToPlay;
          statusColor = AppColors.grey;
          statusIcon = Icons.play_circle_outline_rounded;
        }

        return Row(
          children: [
            // Reciter Avatar with Decorative Accent
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isPlaying
                          ? AppColors.primaryDeep
                          : AppColors.primaryLight,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isPlaying
                            ? AppColors.primary.withValues(alpha: 0.35)
                            : Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.cardBackground,
                backgroundImage: AssetImage(AppAssets.reciterImage),
              ),
            ),
            const SizedBox(width: 16),

            // Surah & Reciter Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Reciter Name
                  Row(
                    children: [
                      const Icon(
                        Icons.mic_rounded,
                        size: 16,
                        color: AppColors.primaryDeep,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.reciterName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDeep,
                          fontFamily: AppStrings.fontCairo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Surah Name
                  Text(
                    surah != null ? 'سورة ${surah.name}' : 'اختر سورة',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      fontFamily: AppStrings.fontRakkas,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Status badge and Surah number
                  Row(
                    children: [
                      if (surah != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(
                              alpha: 0.25,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'سورة ${surah.index}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDeep,
                              fontFamily: AppStrings.fontCairo,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, size: 12, color: statusColor),
                            const SizedBox(width: 4),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                                fontFamily: AppStrings.fontCairo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
