import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/quran_audio_controller.dart';
import '../models/audio_surah_model.dart';

class AudioSurahTile extends GetView<QuranAudioController> {
  final AudioSurahModel surah;

  const AudioSurahTile({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isCurrent = controller.currentSurah.value?.index == surah.index;
      final isPlaying = isCurrent && controller.isPlaying.value;
      final isLoading = isCurrent && controller.isLoading.value;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        decoration: BoxDecoration(
          color:
              isCurrent
                  ? AppColors.primaryLight.withValues(alpha: 0.18)
                  : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isCurrent
                    ? AppColors.primaryDeep
                    : AppColors.primary.withValues(alpha: 0.12),
            width: isCurrent ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isCurrent
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.02),
              blurRadius: isCurrent ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.playSurah(surah),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                // Surah Number in Islamic Badge
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color:
                        isCurrent
                            ? AppColors.primaryDeep
                            : AppColors.cardBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isCurrent
                              ? AppColors.primaryDeep
                              : AppColors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${surah.index}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            isCurrent ? AppColors.white : AppColors.primaryDeep,
                        fontFamily: AppStrings.fontCairo,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Surah Name and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'سورة ${surah.name}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color:
                              isCurrent
                                  ? AppColors.primaryDeep
                                  : AppColors.black,
                          fontFamily: AppStrings.fontCairo,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.audiotrack_rounded,
                            size: 13,
                            color:
                                isCurrent
                                    ? AppColors.primaryDeep
                                    : AppColors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppStrings.reciterName,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isCurrent
                                      ? AppColors.primaryDeep
                                      : Colors.grey.shade600,
                              fontFamily: AppStrings.fontCairo,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trailing Action / State
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isCurrent
                            ? AppColors.primaryDeep
                            : AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                            : Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color:
                                  isCurrent
                                      ? AppColors.white
                                      : AppColors.primaryDeep,
                              size: 24,
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
