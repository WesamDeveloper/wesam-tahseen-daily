import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../models/quran_bookmark.dart';
import '../models/surah_model.dart';
import '../repositories/quran_repository.dart';

class QuranController extends GetxController {
  final QuranRepository _repository;
  final StorageService _storage = Get.find<StorageService>();

  QuranController({required QuranRepository repository})
    : _repository = repository;

  final RxList<SurahModel> surahs = <SurahModel>[].obs;
  final RxList<SurahModel> filteredSurahs = <SurahModel>[].obs;
  final RxString searchQuery = ''.obs;

  // Last Quran Bookmark
  final Rx<QuranBookmark?> bookmark = Rx<QuranBookmark?>(null);

  @override
  void onInit() {
    super.onInit();
    loadSurahs();
    loadBookmark();
  }

  void loadBookmark() {
    bookmark.value = _storage.getQuranBookmark();
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
    Get.toNamed(AppRoutes.surah, arguments: surah)?.then((_) {
      loadBookmark();
    });
  }

  void continueReadingFromBookmark() {
    final b = bookmark.value;
    if (b == null) return;
    Get.toNamed(
      AppRoutes.surah,
      arguments: {
        'num': b.surahNumber,
        'title': b.surahName,
        'targetAyah': b.ayahNumber,
      },
    )?.then((_) {
      loadBookmark();
    });
  }
}
