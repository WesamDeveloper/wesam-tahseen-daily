import '../features/quran/models/surah_model.dart';

final List<Map<String, String>> surahs =
    SurahModel.allSurahs
        .map((s) => {"index": s.index.toString(), "name": s.name})
        .toList();
