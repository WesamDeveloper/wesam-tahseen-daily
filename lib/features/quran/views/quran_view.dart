import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/quran_controller.dart';
import '../widgets/surah_tile.dart';

class QuranView extends GetView<QuranController> {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.quranTitle,
          style: TextStyle(fontFamily: AppStrings.fontRakkas),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.surahs.length,
          itemBuilder: (ctx, i) {
            final surah = controller.surahs[i];
            return SurahTile(
              surah: surah,
              onTap: () => controller.onSelectSurah(surah),
            );
          },
        ),
      ),
    );
  }
}
