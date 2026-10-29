import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../models/surah_model.dart';
import '../repositories/quran_repository.dart';

class QuranController extends GetxController {
  final QuranRepository _repository;

  QuranController({required QuranRepository repository})
    : _repository = repository;

  final RxList<SurahModel> surahs = <SurahModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSurahs();
  }

  void loadSurahs() {
    surahs.assignAll(_repository.getSurahs());
  }

  void onSelectSurah(SurahModel surah) {
    Get.toNamed(AppRoutes.surah, arguments: surah);
  }
}
