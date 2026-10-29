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
      final list = await _repository.getVersesForSurah(surahNumber);
      verses.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
