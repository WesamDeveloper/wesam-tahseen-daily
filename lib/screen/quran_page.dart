import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/quran/controllers/quran_controller.dart';
import '../features/quran/repositories/quran_repository.dart';
import '../features/quran/views/quran_view.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<QuranRepository>()) {
      Get.lazyPut<QuranRepository>(() => QuranRepository());
    }
    if (!Get.isRegistered<QuranController>()) {
      Get.lazyPut<QuranController>(
        () => QuranController(repository: Get.find<QuranRepository>()),
      );
    }
    return const QuranView();
  }
}
