import 'package:get/get.dart';
import '../models/ayah_model.dart';
import '../models/surah_model.dart';
import '../repositories/quran_repository.dart';

class SurahDetailController extends GetxController {
  final QuranRepository _repository;

  SurahDetailController({required QuranRepository repository})
    : _repository = repository;

  int surahNumber = 1;
  String surahTitle = 'الفاتحة';

  final RxList<AyahModel> verses = <AyahModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Reading Experience Settings
  final RxString surahType = 'مكية'.obs;
  final RxInt totalVerses = 0.obs;
  final RxDouble fontSize = 24.0.obs;
  final RxInt readingThemeIndex = 0.obs; // 0: Sepia, 1: White, 2: Dark
  final RxBool isMushafMode = true.obs; // true: Mushaf flow, false: Verse cards

  bool get hasNextSurah => surahNumber < 114;
  bool get hasPreviousSurah => surahNumber > 1;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is SurahModel) {
      surahNumber = args.index;
      surahTitle = args.name;
    } else if (args is Map) {
      surahNumber =
          args['num'] is int ? args['num'] : int.parse(args['num'].toString());
      surahTitle = args['title']?.toString() ?? '';
    }
    loadVerses();
  }

  void setSurah(int num, String title) {
    surahNumber = num;
    surahTitle = title;
    loadVerses();
  }

  Future<void> loadVerses() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final info = await _repository.getSurahInfo(surahNumber);
      if (info != null) {
        surahType.value = info['type'] as String? ?? 'مكية';
        totalVerses.value = info['total_verses'] as int? ?? 0;
      }
      final list = await _repository.getVersesForSurah(surahNumber);
      verses.assignAll(list);
      if (totalVerses.value == 0) {
        totalVerses.value = list.length;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void goToNextSurah() {
    if (hasNextSurah) {
      final next = SurahModel.allSurahs[surahNumber];
      setSurah(next.index, next.name);
    }
  }

  void goToPreviousSurah() {
    if (hasPreviousSurah) {
      final prev = SurahModel.allSurahs[surahNumber - 2];
      setSurah(prev.index, prev.name);
    }
  }

  void increaseFontSize() {
    if (fontSize.value < 38) {
      fontSize.value += 2;
    }
  }

  void decreaseFontSize() {
    if (fontSize.value > 18) {
      fontSize.value -= 2;
    }
  }

  void setFontSize(double size) {
    fontSize.value = size.clamp(18, 38);
  }

  void setReadingTheme(int index) {
    readingThemeIndex.value = index;
  }

  void toggleMushafMode() {
    isMushafMode.value = !isMushafMode.value;
  }
}
