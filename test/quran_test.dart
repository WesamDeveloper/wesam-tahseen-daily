import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dene/core/services/storage_service.dart';
import 'package:dene/features/quran/controllers/quran_controller.dart';
import 'package:dene/features/quran/models/surah_model.dart';
import 'package:dene/features/quran/models/ayah_model.dart';
import 'package:dene/features/quran/models/quran_bookmark.dart';
import 'package:dene/features/quran/repositories/quran_repository.dart';
import 'package:dene/features/quran/views/quran_view.dart';

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

    test('QuranBookmark model serializes and deserializes properly', () {
      final now = DateTime.now();
      final bookmark = QuranBookmark(
        surahNumber: 2,
        surahName: 'البقرة',
        ayahNumber: 255,
        ayahText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        timestamp: now,
      );

      final json = bookmark.toJson();
      expect(json['surah_number'], 2);
      expect(json['surah_name'], 'البقرة');
      expect(json['ayah_number'], 255);
      expect(json['ayah_text'], 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ');

      final deserialized = QuranBookmark.fromJson(json);
      expect(deserialized.surahNumber, 2);
      expect(deserialized.surahName, 'البقرة');
      expect(deserialized.ayahNumber, 255);
      expect(deserialized.ayahText, 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ');
    });

    test('StorageService persists, retrieves and removes Quran Bookmark', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = StorageService();
      await storage.init();

      expect(storage.getQuranBookmark(), isNull);
      expect(storage.hasQuranBookmark(), isFalse);

      final bookmark = QuranBookmark(
        surahNumber: 18,
        surahName: 'الكهف',
        ayahNumber: 10,
        ayahText: 'إِذْ أَوَى الْفِتْيَةُ إِلَى الْكَهْفِ',
        timestamp: DateTime.now(),
      );

      await storage.saveQuranBookmark(bookmark);

      expect(storage.hasQuranBookmark(), isTrue);
      final retrieved = storage.getQuranBookmark();
      expect(retrieved, isNotNull);
      expect(retrieved!.surahNumber, 18);
      expect(retrieved.surahName, 'الكهف');
      expect(retrieved.ayahNumber, 10);
      expect(retrieved.ayahText, 'إِذْ أَوَى الْفِتْيَةُ إِلَى الْكَهْفِ');

      await storage.removeQuranBookmark();
      expect(storage.hasQuranBookmark(), isFalse);
      expect(storage.getQuranBookmark(), isNull);
    });

    testWidgets('QuranView Bookmark Card renders cleanly with Surah name and no Ayah text quote', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({
        'quran_bookmark_surah': 2,
        'quran_bookmark_surah_name': 'البقرة',
        'quran_bookmark_ayah': 255,
        'quran_bookmark_ayah_text': 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
      });

      Get.testMode = true;
      final storage = StorageService();
      await storage.init();
      Get.put<StorageService>(storage);

      final repo = QuranRepository();
      Get.put<QuranRepository>(repo);
      Get.put<QuranController>(QuranController(repository: repo));

      await tester.pumpWidget(
        const GetMaterialApp(
          locale: Locale('ar'),
          home: QuranView(),
        ),
      );
      await tester.pumpAndSettle();

      // Bookmark banner is displayed
      expect(find.text('فاصل القراءة 🔖'), findsOneWidget);
      expect(find.text('سورة البقرة • الآية (255)'), findsOneWidget);

      // Verify that the ayah text quote is NOT shown as requested by user
      expect(find.textContaining('اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ'), findsNothing);
      expect(find.text('متابعة'), findsOneWidget);

      final exception = tester.takeException();
      if (exception is FlutterError) {
        debugPrint('TEST EXCEPTION DETAILS: ${exception.toStringDeep()}');
      }
      expect(exception, isNull);

      Get.reset();
    });
  });
}
