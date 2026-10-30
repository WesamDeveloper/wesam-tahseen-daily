import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/storage_service.dart';
import '../models/ayah_model.dart';
import '../models/quran_bookmark.dart';
import '../models/surah_model.dart';
import '../repositories/quran_repository.dart';

class SurahDetailController extends GetxController {
  final QuranRepository _repository;
  final StorageService _storage = Get.find<StorageService>();

  SurahDetailController({required QuranRepository repository})
    : _repository = repository;

  int surahNumber = 1;
  String surahTitle = 'الفاتحة';
  int? targetAyah;

  final ScrollController scrollController = ScrollController();
  final Map<int, GlobalKey> ayahKeys = <int, GlobalKey>{};

  final RxList<AyahModel> verses = <AyahModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Reading Experience Settings
  final RxString surahType = 'مكية'.obs;
  final RxInt totalVerses = 0.obs;
  final RxDouble fontSize = 24.0.obs;
  final RxInt readingThemeIndex = 0.obs; // 0: Sepia, 1: White, 2: Dark
  final RxBool isMushafMode = true.obs; // true: Mushaf flow, false: Verse cards

  // Bookmark & Navigation
  final Rx<QuranBookmark?> bookmark = Rx<QuranBookmark?>(null);
  final RxInt highlightedAyah = 0.obs;

  bool get hasNextSurah => surahNumber < 114;
  bool get hasPreviousSurah => surahNumber > 1;

  bool isAyahBookmarked(int ayahNum) {
    final b = bookmark.value;
    return b != null &&
        b.surahNumber == surahNumber &&
        b.ayahNumber == ayahNum;
  }

  bool get hasBookmarkInCurrentSurah {
    final b = bookmark.value;
    return b != null && b.surahNumber == surahNumber;
  }

  GlobalKey getAyahKey(int ayahNum) {
    return ayahKeys.putIfAbsent(ayahNum, () => GlobalKey());
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is SurahModel) {
      surahNumber = args.index;
      surahTitle = args.name;
    } else if (args is Map) {
      surahNumber =
          args['num'] is int ? args['num'] : int.parse(args['num'].toString());
      surahTitle = args['title']?.toString() ?? '';
      if (args['targetAyah'] != null) {
        targetAyah =
            args['targetAyah'] is int
                ? args['targetAyah'] as int
                : int.tryParse(args['targetAyah'].toString());
      }
    }
    loadBookmark();
    loadVerses();
  }

  void loadBookmark() {
    bookmark.value = _storage.getQuranBookmark();
  }

  void setSurah(int num, String title, [int? initialAyah]) {
    surahNumber = num;
    surahTitle = title;
    targetAyah = initialAyah;
    ayahKeys.clear();
    loadVerses();
  }

  Future<void> loadVerses() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final info = await _repository.getSurahInfo(surahNumber);
      if (info != null) {
        surahType.value = info['type'] as String? ?? 'مكية';
        totalVerses.value = info['total_verses'] as int? ?? 0;
      }
      final list = await _repository.getVersesForSurah(surahNumber);
      verses.assignAll(list);
      if (totalVerses.value == 0) {
        totalVerses.value = list.length;
      }

      // If navigation requested a specific ayah (e.g. from bookmark), scroll to it
      if (targetAyah != null) {
        final toScroll = targetAyah!;
        targetAyah = null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 300), () {
            scrollToAyah(toScroll, highlight: true);
          });
        });
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void goToNextSurah() {
    if (hasNextSurah) {
      final next = SurahModel.allSurahs[surahNumber];
      setSurah(next.index, next.name);
    }
  }

  void goToPreviousSurah() {
    if (hasPreviousSurah) {
      final prev = SurahModel.allSurahs[surahNumber - 2];
      setSurah(prev.index, prev.name);
    }
  }

  void increaseFontSize() {
    if (fontSize.value < 38) {
      fontSize.value += 2;
    }
  }

  void decreaseFontSize() {
    if (fontSize.value > 18) {
      fontSize.value -= 2;
    }
  }

  void setFontSize(double size) {
    fontSize.value = size.clamp(18, 38);
  }

  void setReadingTheme(int index) {
    readingThemeIndex.value = index;
  }

  void toggleMushafMode() {
    ayahKeys.clear();
    isMushafMode.value = !isMushafMode.value;
  }

  // --- Bookmark Operations ---
  Future<void> toggleBookmark(AyahModel ayah) async {
    if (isAyahBookmarked(ayah.ayah)) {
      await removeBookmark();
    } else {
      await setBookmark(ayah);
    }
  }

  Future<void> setBookmark(AyahModel ayah) async {
    final newBookmark = QuranBookmark(
      surahNumber: surahNumber,
      surahName: surahTitle,
      ayahNumber: ayah.ayah,
      ayahText: ayah.text.trim(),
      timestamp: DateTime.now(),
    );
    await _storage.saveQuranBookmark(newBookmark);
    bookmark.value = newBookmark;
    HapticFeedback.mediumImpact();

    _showSnackbar(
      title: 'فاصل القراءة 🔖',
      message: 'تم حفظ الفاصل عند سورة $surahTitle (الآية ${ayah.ayah}) بنجاح',
      icon: Icons.bookmark_added_rounded,
      iconColor: const Color(0xFFF59E0B),
    );
  }

  Future<void> removeBookmark() async {
    await _storage.removeQuranBookmark();
    bookmark.value = null;
    HapticFeedback.lightImpact();

    _showSnackbar(
      title: 'فاصل القراءة',
      message: 'تمت إزالة الفاصل بنجاح',
      icon: Icons.bookmark_remove_rounded,
      iconColor: Colors.white70,
    );
  }

  void scrollToAyah(int ayahNum, {bool highlight = true, int attempts = 0}) {
    if (verses.isEmpty) return;

    if (highlight && attempts == 0) {
      highlightedAyah.value = ayahNum;
      Future.delayed(const Duration(milliseconds: 3000), () {
        if (highlightedAyah.value == ayahNum) {
          highlightedAyah.value = 0;
        }
      });
    }

    final key = ayahKeys[ayahNum];
    final ctx = key?.currentContext;
    final renderBox = ctx?.findRenderObject() as RenderBox?;

    if (ctx != null && renderBox != null && renderBox.hasSize) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
        alignment: 0.0, // Exactly at the top edge of the reading view
      );
      return;
    }

    // If context or renderbox is not mounted/sized yet, retry every 40ms up to 20 attempts
    if (attempts < 20) {
      Future.delayed(const Duration(milliseconds: 40), () {
        scrollToAyah(ayahNum, highlight: false, attempts: attempts + 1);
      });
    }
  }

  void jumpToBookmark(BuildContext context) {
    final b = bookmark.value;
    if (b == null) {
      _showSnackbar(
        title: 'فاصل القراءة',
        message: AppStrings.quranBookmarkEmpty,
        icon: Icons.info_outline_rounded,
        iconColor: const Color(0xFF38BDF8),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (b.surahNumber == surahNumber) {
      scrollToAyah(b.ayahNumber, highlight: true);
      HapticFeedback.selectionClick();
      _showSnackbar(
        title: 'فاصل القراءة 🔖',
        message: 'تم الانتقال إلى فاصل القراءة (الآية ${b.ayahNumber})',
        icon: Icons.bookmark_rounded,
        iconColor: const Color(0xFFF59E0B),
      );
    } else {
      _showJumpToOtherSurahDialog(context, b);
    }
  }

  void _showJumpToOtherSurahDialog(BuildContext context, QuranBookmark b) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.bookmark_rounded,
                  color: Color(0xFFD97706),
                  size: 22,
                ),
                SizedBox(width: 8),
                Text(
                  'فاصل القراءة 🔖',
                  style: TextStyle(
                    fontFamily: AppStrings.fontCairo,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            content: Text(
              'فاصل القراءة محفوظ في سورة "${b.surahName}" عند الآية (${b.ayahNumber}).\n\nهل ترغب بالانتقال إليها الآن ومتابعة قراءتك؟',
              style: const TextStyle(
                fontFamily: AppStrings.fontCairo,
                fontSize: 13.5,
                height: 1.6,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: AppStrings.fontCairo,
                    color: Colors.grey,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  setSurah(b.surahNumber, b.surahName, b.ayahNumber);
                },
                child: Text(
                  'الانتقال إلى سورة ${b.surahName}',
                  style: const TextStyle(
                    fontFamily: AppStrings.fontCairo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void shareAyah(AyahModel ayah) {
    final text =
        '﴿ ${ayah.text.trim()} ﴾\n[سورة $surahTitle - الآية ${ayah.ayah}]\n\n'
        'تطبيق وسام للتحصين اليومي 🌿\n${AppStrings.developerTelegramUrl}';
    SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: 'آية من سورة $surahTitle',
      ),
    );
  }

  void _showSnackbar({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    if (Get.context != null) {
      Get.rawSnackbar(
        messageText: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: AppStrings.fontCairo,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: duration,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
