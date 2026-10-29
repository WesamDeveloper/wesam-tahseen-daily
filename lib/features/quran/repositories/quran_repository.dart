import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/constants/app_assets.dart';
import '../models/ayah_model.dart';
import '../models/surah_model.dart';

class QuranRepository {
  List<AyahModel>? _cachedAyahs;

  List<SurahModel> getSurahs() {
    return SurahModel.allSurahs;
  }

  Future<List<AyahModel>> _loadAllAyahs() async {
    if (_cachedAyahs != null) return _cachedAyahs!;

    final raw = await rootBundle.loadString(AppAssets.quranFullJson);
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;

    final List<AyahModel> list = [];
    for (final s in data) {
      final int surah = s['id'] as int;
      for (final v in s['verses']) {
        list.add(
          AyahModel(
            surah: surah,
            ayah: v['id'] as int,
            text: v['text'] as String,
          ),
        );
      }
    }
    _cachedAyahs = list;
    return list;
  }

  Future<List<AyahModel>> getVersesForSurah(int surahNum) async {
    final all = await _loadAllAyahs();
    return all.where((a) => a.surah == surahNum).toList();
  }
}
