class AyahModel {
  final int surah;
  final int ayah;
  final String text;

  const AyahModel({
    required this.surah,
    required this.ayah,
    required this.text,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      surah: json['surah'] as int,
      ayah: json['ayah'] as int,
      text: json['text'] as String,
    );
  }
}
