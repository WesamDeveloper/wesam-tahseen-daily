class ZikrItem {
  final String text;
  final int initialCount;
  int count;
  final String? virtue;
  final String? reference;

  ZikrItem({
    required this.text,
    required this.initialCount,
    int? currentCount,
    this.virtue,
    this.reference,
  }) : count = currentCount ?? initialCount;

  ZikrItem copyWith({
    String? text,
    int? initialCount,
    int? count,
    String? virtue,
    String? reference,
  }) {
    return ZikrItem(
      text: text ?? this.text,
      initialCount: initialCount ?? this.initialCount,
      currentCount: count ?? this.count,
      virtue: virtue ?? this.virtue,
      reference: reference ?? this.reference,
    );
  }
}

