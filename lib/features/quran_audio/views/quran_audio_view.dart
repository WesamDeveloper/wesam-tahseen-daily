import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/quran_audio_controller.dart';
import '../widgets/audio_player_controls.dart';
import '../widgets/audio_progress_bar.dart';
import '../widgets/audio_surah_tile.dart';
import '../widgets/reciter_header_card.dart';
import '../widgets/surah_search_bar.dart';

class QuranAudioView extends GetView<QuranAudioController> {
  const QuranAudioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            AppStrings.quranAudioTitle,
            style: TextStyle(fontFamily: AppStrings.fontRakkas),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Player Area (Card, Progress Bar, Controls)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6),
                    const ReciterHeaderCard(),
                    const AudioProgressBar(),
                    const AudioPlayerControls(),
                    const SizedBox(height: 6),
                    const SurahSearchBar(),
                    const SizedBox(height: 6),
                  ],
                ),
              ),

              // Surahs List / Empty State / Error Banner
              Expanded(
                child: Obx(() {
                  final surahs = controller.filteredSurahs;

                  return Column(
                    children: [
                      // Non-blocking error banner (keeps surahs list fully accessible)
                      if (controller.hasError.value)
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  final current = controller.currentSurah.value;
                                  if (current != null) {
                                    controller.playSurah(current);
                                  }
                                },
                                child: const Text(AppStrings.retry),
                              ),
                            ],
                          ),
                        ),

                      // Surah List or Empty Search
                      Expanded(
                        child:
                            surahs.isEmpty
                                ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search_off_rounded,
                                          size: 56,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          AppStrings.noSurahsFound,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.grey,
                                            fontFamily: AppStrings.fontCairo,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextButton(
                                          onPressed: controller.clearSearch,
                                          child: const Text('عرض جميع السور'),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  padding: const EdgeInsets.only(
                                    bottom: 24,
                                    top: 4,
                                  ),
                                  itemCount: surahs.length,
                                  itemBuilder: (context, index) {
                                    return AudioSurahTile(surah: surahs[index]);
                                  },
                                ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
