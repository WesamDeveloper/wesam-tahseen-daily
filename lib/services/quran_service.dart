import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/ayah.dart';

class QuranService {
  static List<Ayah>? _cache;

  static Future<List<Ayah>> _loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/quran/quran_full.json');
    final List data = jsonDecode(raw);

    final List<Ayah> list = [];
    for (final s in data) {
      final int surah = s['id'];
      for (final v in s['verses']) {
        list.add(Ayah(surah: surah, ayah: v['id'], text: v['text']));
      }
    }
    _cache = list;
    return list;
  }

  static Future<List<Ayah>> getSurah(int surahNum) async {
    final all = await _loadAll();
    return all.where((a) => a.surah == surahNum).toList();
  }
}
