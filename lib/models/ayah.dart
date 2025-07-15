class Ayah {
  final int surah;
  final int ayah;
  final String text;

  Ayah({required this.surah, required this.ayah, required this.text});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      surah: json['surah'],
      ayah: json['ayah'],
      text: json['text'],
    );
  }
}