import 'package:get/get.dart';
import '../controllers/surah_detail_controller.dart';
import '../repositories/quran_repository.dart';

class SurahDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<QuranRepository>()) {
      Get.lazyPut<QuranRepository>(() => QuranRepository());
    }
    Get.lazyPut<SurahDetailController>(
      () => SurahDetailController(repository: Get.find<QuranRepository>()),
    );
  }
}
