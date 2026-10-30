import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/home/controllers/home_controller.dart';
import '../features/home/views/home_view.dart';
import '../features/about/controllers/about_controller.dart';
import '../features/quran/controllers/quran_controller.dart';
import '../features/quran/repositories/quran_repository.dart';
import '../features/quran_audio/controllers/quran_audio_controller.dart';
import '../features/quran_audio/services/quran_audio_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }
    if (!Get.isRegistered<QuranRepository>()) {
      Get.lazyPut<QuranRepository>(() => QuranRepository());
    }
    if (!Get.isRegistered<QuranController>()) {
      Get.lazyPut<QuranController>(
        () => QuranController(repository: Get.find<QuranRepository>()),
      );
    }
    if (!Get.isRegistered<QuranAudioService>()) {
      Get.lazyPut<QuranAudioService>(() => QuranAudioService());
    }
    if (!Get.isRegistered<QuranAudioController>()) {
      Get.lazyPut<QuranAudioController>(
        () => QuranAudioController(audioService: Get.find<QuranAudioService>()),
      );
    }
    if (!Get.isRegistered<AboutController>()) {
      Get.lazyPut<AboutController>(() => AboutController());
    }
    return const HomeView();
  }
}
