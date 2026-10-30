import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/constants/app_assets.dart';
import '../models/ayah_model.dart';
import '../models/surah_model.dart';

class QuranRepository {
  List<AyahModel>? _cachedAyahs;
  Map<int, Map<String, dynamic>> _surahInfoMap = {};

  List<SurahModel> getSurahs() {
    return SurahModel.allSurahs;
  }

  Future<void> _ensureLoaded() async {
    if (_cachedAyahs != null) return;

    final raw = await rootBundle.loadString(AppAssets.quranFullJson);
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;

    final List<AyahModel> list = [];
    final Map<int, Map<String, dynamic>> infoMap = {};

    for (final s in data) {
      final int surahId = s['id'] as int;
      final versesList = s['verses'] as List<dynamic>? ?? [];

      infoMap[surahId] = {
        'id': surahId,
        'name': s['name'] as String? ?? '',
        'type': (s['type'] as String?) == 'meccan' ? 'مكية' : 'مدنية',
        'total_verses': s['total_verses'] as int? ?? versesList.length,
        'transliteration': s['transliteration'] as String? ?? '',
      };

      for (final v in versesList) {
        list.add(
          AyahModel(
            surah: surahId,
            ayah: v['id'] as int,
            text: v['text'] as String,
          ),
        );
      }
    }
    _cachedAyahs = list;
    _surahInfoMap = infoMap;
  }

  Future<Map<String, dynamic>?> getSurahInfo(int surahNum) async {
    await _ensureLoaded();
    return _surahInfoMap[surahNum];
  }

  Future<List<AyahModel>> getVersesForSurah(int surahNum) async {
    await _ensureLoaded();
    return _cachedAyahs!.where((a) => a.surah == surahNum).toList();
  }
}
