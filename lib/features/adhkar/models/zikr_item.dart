class ZikrItem {
  final String text;
  final int initialCount;
  int count;

  ZikrItem({required this.text, required this.initialCount, int? currentCount})
    : count = currentCount ?? initialCount;

  ZikrItem copyWith({String? text, int? initialCount, int? count}) {
    return ZikrItem(
      text: text ?? this.text,
      initialCount: initialCount ?? this.initialCount,
      currentCount: count ?? this.count,
    );
  }
}
