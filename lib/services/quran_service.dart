import '../features/quran/repositories/quran_repository.dart';
import '../models/ayah.dart';

class QuranService {
  static final QuranRepository _repository = QuranRepository();

  static Future<List<Ayah>> getSurah(int surahNum) async {
    final list = await _repository.getVersesForSurah(surahNum);
    return list
        .map((a) => Ayah(surah: a.surah, ayah: a.ayah, text: a.text))
        .toList();
  }
}
