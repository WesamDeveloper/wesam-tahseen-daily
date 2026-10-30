import '../../quran/models/surah_model.dart';

class AudioSurahModel {
  final int index;
  final String name;
  final String fileName;
  final String assetPath;
  final bool isAvailable;

  const AudioSurahModel({
    required this.index,
    required this.name,
    required this.fileName,
    required this.assetPath,
    this.isAvailable = true,
  });

  String get formattedIndex => index.toString().padLeft(3, '0');

  static List<AudioSurahModel> getAllSurahs() {
    return SurahModel.allSurahs.map((s) {
      final formatted = s.index.toString().padLeft(3, '0');
      return AudioSurahModel(
        index: s.index,
        name: s.name,
        fileName: '$formatted.mp3',
        assetPath: 'assets/audio/$formatted.mp3',
        isAvailable: true,
      );
    }).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioSurahModel &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  int get hashCode => index.hashCode;
}
