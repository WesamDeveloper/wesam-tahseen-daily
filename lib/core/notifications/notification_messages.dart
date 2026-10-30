import 'dart:math';

class QuranReminderMessage {
  final int id;
  final String title;
  final String Function(String? name) formatBody;
  final bool isPersonalizable;

  const QuranReminderMessage({
    required this.id,
    required this.title,
    required this.formatBody,
    this.isPersonalizable = true,
  });

  String getBody([String? name]) {
    final cleanName = name?.trim();
    final validName = (cleanName != null && cleanName.isNotEmpty) ? cleanName : null;
    return formatBody(validName);
  }
}

class NotificationMessages {
  NotificationMessages._();

  static const String defaultTitle = 'تذكير بالقرآن الكريم';

  static final List<QuranReminderMessage> messages = [
    // 1 - Motivational
    QuranReminderMessage(
      id: 1,
      title: 'نور لقلبك 🌿',
      isPersonalizable: false,
      formatBody: (_) => 'لا تجعل يومك يخلو من القرآن، ولو بآيات قليلة ❤️',
    ),
    // 2 - Motivational
    QuranReminderMessage(
      id: 2,
      title: 'آية تغيّر يومك ✨',
      isPersonalizable: false,
      formatBody: (_) => 'افتح مصحفك، فرب آية تغيّر يومك كله 🌿',
    ),
    // 3 - Motivational
    QuranReminderMessage(
      id: 3,
      title: 'طمأنينة الروح 🌸',
      isPersonalizable: false,
      formatBody: (_) => 'اجعل للقرآن نصيبًا من وقتك، فهو نور قلبك.',
    ),
    // 4 - Motivational
    QuranReminderMessage(
      id: 4,
      title: 'دقائق مع كتاب الله 📖',
      isPersonalizable: false,
      formatBody: (_) => 'دقائق مع القرآن قد تمنح قلبك طمأنينة لا توصف.',
    ),
    // 5 - Friendly
    QuranReminderMessage(
      id: 5,
      title: 'اشتقنا لتلاوتك ❤️',
      isPersonalizable: true,
      formatBody: (name) => name != null
          ? 'لقد اشتقنا لقراءتك يا $name، ألا نفتح المصحف اليوم؟'
          : 'لقد اشتقنا لقراءتك، ألا نفتح المصحف اليوم؟',
    ),
    // 6 - Friendly
    QuranReminderMessage(
      id: 6,
      title: 'آيات تنتظرك 🌿',
      isPersonalizable: true,
      formatBody: (name) => name != null
          ? 'يا $name، هناك آيات تنتظر أن تمر عليها عيناك اليوم ❤️'
          : 'هناك آيات تنتظر أن تمر عليها عيناك اليوم ❤️',
    ),
    // 7 - Friendly
    QuranReminderMessage(
      id: 7,
      title: 'رفيق اليوم ✨',
      isPersonalizable: true,
      formatBody: (name) => name != null
          ? 'ما رأيك يا $name أن تجعل القرآن رفيق يومك؟'
          : 'ما رأيك أن تجعل القرآن رفيق يومك؟',
    ),
    // 8 - Gentle reproach / reminder
    QuranReminderMessage(
      id: 8,
      title: 'عتاب محب 🌸',
      isPersonalizable: true,
      formatBody: (name) => name != null
          ? 'لقد هجرتني يا $name، لماذا لا تعود لقراءتي؟'
          : 'لقد هجرتني، لماذا لا تعود لقراءتي؟',
    ),
    // 9 - Reminder
    QuranReminderMessage(
      id: 9,
      title: 'وردك اليومي 📖',
      isPersonalizable: true,
      formatBody: (name) => name != null
          ? 'يا $name، لا تنسَ وردك من القرآن، ولو كان قليلًا.'
          : 'لا تنسَ وردك من القرآن، ولو كان قليلًا.',
    ),
    // 10 - Reminder
    QuranReminderMessage(
      id: 10,
      title: 'مصحفك ينتظرك ❤️',
      isPersonalizable: true,
      formatBody: (name) => name != null
          ? 'مصحفك ينتظرك يا $name، فلا تحرمه من وقتك.'
          : 'مصحفك ينتظرك، فلا تحرمه من وقتك.',
    ),
    // 11 - Direct Invitation
    QuranReminderMessage(
      id: 11,
      title: 'دعنا نقرأ القرآن 🌿',
      isPersonalizable: true,
      formatBody: (name) => name != null
          ? 'دعنا نقرأ القرآن يا $name اليوم ❤️'
          : 'دعنا نقرأ القرآن اليوم ❤️',
    ),
    // 12 - Personalized / General
    QuranReminderMessage(
      id: 12,
      title: 'بركة اليوم ✨',
      isPersonalizable: true,
      formatBody: (name) => name != null
          ? '$name، لا تجعل يومك يمر دون ورد من القرآن.'
          : 'لا تجعل يومك يمر دون ورد من القرآن.',
    ),
    // 13 - Personalized / General
    QuranReminderMessage(
      id: 13,
      title: 'افتح مصحفك 📖',
      isPersonalizable: true,
      formatBody: (name) => name != null
          ? '$name، افتح مصحفك واجعل القرآن رفيق يومك.'
          : 'افتح مصحفك واجعل القرآن رفيق يومك.',
    ),
    // 14 - Spiritual
    QuranReminderMessage(
      id: 14,
      title: 'ألا بذكر الله تطمئن القلوب 🌸',
      isPersonalizable: false,
      formatBody: (_) => 'صفحة واحدة من القرآن تنير لك سائر يومك وتبارك في وقتك.',
    ),
    // 15 - Spiritual
    QuranReminderMessage(
      id: 15,
      title: 'نور وشفاعة ✨',
      isPersonalizable: true,
      formatBody: (name) => name != null
          ? 'يا $name، كن مع القرآن، يكن القرآن معك شفيعًا ونورًا.'
          : 'كن مع القرآن، يكن القرآن معك شفيعًا ونورًا في دربك.',
    ),
    // 16 - Motivational
    QuranReminderMessage(
      id: 16,
      title: 'طوبى للذاكرين 🌿',
      isPersonalizable: false,
      formatBody: (_) => 'طوبى لمن جعل كتاب الله أنيسه وربيع قلبه في كل يوم.',
    ),
  ];

  /// Returns a message avoiding immediate repetition of [lastId].
  static QuranReminderMessage getRandomMessage({int? lastId, Random? random}) {
    final rng = random ?? Random();
    final candidates = (lastId != null && messages.length > 1)
        ? messages.where((m) => m.id != lastId).toList()
        : messages;
    final index = rng.nextInt(candidates.length);
    return candidates[index];
  }
}

