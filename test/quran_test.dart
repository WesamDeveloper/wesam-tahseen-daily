import 'package:flutter_test/flutter_test.dart';
import 'package:dene/features/quran/models/surah_model.dart';
import 'package:dene/features/quran/models/ayah_model.dart';
import 'package:dene/features/quran/repositories/quran_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Quran Tests', () {
    test('All 114 Surahs are accurately defined with 1-based indexing', () {
      expect(SurahModel.allSurahs.length, 114);
      expect(SurahModel.allSurahs.first.index, 1);
      expect(SurahModel.allSurahs.first.name, 'الفاتحة');
      expect(SurahModel.allSurahs.last.index, 114);
      expect(SurahModel.allSurahs.last.name, 'الناس');
    });

    test('AyahModel parses correctly from json', () {
      final json = {
        'surah': 1,
        'ayah': 1,
        'text': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      };
      final ayah = AyahModel.fromJson(json);
      expect(ayah.surah, 1);
      expect(ayah.ayah, 1);
      expect(ayah.text, 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ');
    });

    test('QuranRepository loads surah list', () {
      final repo = QuranRepository();
      final surahs = repo.getSurahs();
      expect(surahs.length, 114);
    });
  });
}
