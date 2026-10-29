import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/quran/controllers/surah_detail_controller.dart';
import '../features/quran/repositories/quran_repository.dart';
import '../features/quran/views/surah_view.dart';

class SurahPage extends StatelessWidget {
  final int num;
  final String title;

  const SurahPage({super.key, required this.num, required this.title});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<QuranRepository>()) {
      Get.lazyPut<QuranRepository>(() => QuranRepository());
    }
    Get.delete<SurahDetailController>();
    final controller = Get.put<SurahDetailController>(
      SurahDetailController(repository: Get.find<QuranRepository>()),
    );
    controller.setSurah(num, title);
    return const SurahView();
  }
}
