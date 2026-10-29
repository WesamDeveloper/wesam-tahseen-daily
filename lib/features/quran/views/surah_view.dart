import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/surah_detail_controller.dart';

class SurahView extends GetView<SurahDetailController> {
  const SurahView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.surahTitle,
          style: const TextStyle(fontFamily: AppStrings.fontRakkas),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(controller.errorMessage.value),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: controller.loadVerses,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              final List<InlineSpan> spans = [];
              for (final a in controller.verses) {
                spans.add(
                  TextSpan(
                    text: '${a.text.trim()} ',
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: AppStrings.fontAmiri,
                      height: 1.8,
                      color: AppColors.black,
                    ),
                  ),
                );
                spans.add(
                  TextSpan(
                    text: '﴿${a.ayah}﴾ ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: AppStrings.fontScheherazade,
                      color: AppColors.quranAyahNumber,
                    ),
                  ),
                );
              }

              return Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: RichText(
                    text: TextSpan(children: spans),
                    textAlign: TextAlign.justify,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
