import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../models/surah_model.dart';
import '../repositories/quran_repository.dart';

class QuranController extends GetxController {
  final QuranRepository _repository;

  QuranController({required QuranRepository repository})
    : _repository = repository;

  final RxList<SurahModel> surahs = <SurahModel>[].obs;
  final RxList<SurahModel> filteredSurahs = <SurahModel>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSurahs();
  }

  void loadSurahs() {
    final list = _repository.getSurahs();
    surahs.assignAll(list);
    filteredSurahs.assignAll(list);
  }

  void filterSurahs(String query) {
    searchQuery.value = query.trim();
    if (searchQuery.isEmpty) {
      filteredSurahs.assignAll(surahs);
    } else {
      final q = searchQuery.value;
      filteredSurahs.assignAll(
        surahs.where(
          (s) =>
              s.name.contains(q) ||
              s.index.toString() == q ||
              s.name
                  .replaceAll('أ', 'ا')
                  .replaceAll('إ', 'ا')
                  .replaceAll('آ', 'ا')
                  .contains(
                    q
                        .replaceAll('أ', 'ا')
                        .replaceAll('إ', 'ا')
                        .replaceAll('آ', 'ا'),
                  ),
        ),
      );
    }
  }

  void onSelectSurah(SurahModel surah) {
    Get.toNamed(AppRoutes.surah, arguments: surah);
  }
}
