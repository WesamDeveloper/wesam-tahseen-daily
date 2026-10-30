import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/quran_audio_controller.dart';

class AudioPlayerControls extends GetView<QuranAudioController> {
  const AudioPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Obx(() {
        final isPlaying = controller.isPlaying.value;
        final isLoading = controller.isLoading.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rewind 10 Seconds
            IconButton(
              tooltip: 'رجوع 10 ثوانٍ',
              iconSize: 28,
              color: AppColors.primaryDeep,
              icon: const Icon(Icons.replay_10_rounded),
              onPressed: () {
                final newPos =
                    controller.position.value - const Duration(seconds: 10);
                controller.seekTo(
                  newPos < Duration.zero ? Duration.zero : newPos,
                );
              },
            ),
            const SizedBox(width: 8),

            // Previous Surah Button
            IconButton(
              tooltip: 'السورة السابقة',
              iconSize: 36,
              color: AppColors.primaryDeep,
              icon: const Icon(Icons.skip_previous_rounded),
              onPressed: controller.playPrevious,
            ),
            const SizedBox(width: 14),

            // Main Play / Pause Button
            GestureDetector(
              onTap: controller.togglePlayPause,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDeep],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDeep.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            ),
                          )
                          : Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 40,
                            color: AppColors.white,
                          ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Next Surah Button
            IconButton(
              tooltip: 'السورة التالية',
              iconSize: 36,
              color: AppColors.primaryDeep,
              icon: const Icon(Icons.skip_next_rounded),
              onPressed: controller.playNext,
            ),
            const SizedBox(width: 8),

            // Forward 10 Seconds
            IconButton(
              tooltip: 'تقديم 10 ثوانٍ',
              iconSize: 28,
              color: AppColors.primaryDeep,
              icon: const Icon(Icons.forward_10_rounded),
              onPressed: () {
                final newPos =
                    controller.position.value + const Duration(seconds: 10);
                final dur = controller.duration.value;
                controller.seekTo(newPos > dur ? dur : newPos);
              },
            ),
          ],
        );
      }),
    );
  }
}
