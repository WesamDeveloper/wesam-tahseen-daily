class QuranBookmark {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String? ayahText;
  final DateTime timestamp;

  const QuranBookmark({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    this.ayahText,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'surah_number': surahNumber,
    'surah_name': surahName,
    'ayah_number': ayahNumber,
    'ayah_text': ayahText,
    'timestamp': timestamp.toIso8601String(),
  };

  factory QuranBookmark.fromJson(Map<String, dynamic> json) {
    return QuranBookmark(
      surahNumber: json['surah_number'] as int? ?? 1,
      surahName: json['surah_name'] as String? ?? '',
      ayahNumber: json['ayah_number'] as int? ?? 1,
      ayahText: json['ayah_text'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

