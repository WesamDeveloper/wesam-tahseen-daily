import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/surah_detail_controller.dart';
import '../models/ayah_model.dart';
import '../models/surah_model.dart';

class _QuranThemeData {
  final Color backgroundColor;
  final Color pageSurface;
  final Color textColor;
  final Color ayahNumberColor;
  final Color accentColor;
  final Color appBarColor;
  final Color borderColor;
  final bool isDark;

  const _QuranThemeData({
    required this.backgroundColor,
    required this.pageSurface,
    required this.textColor,
    required this.ayahNumberColor,
    required this.accentColor,
    required this.appBarColor,
    required this.borderColor,
    this.isDark = false,
  });
}

class SurahView extends GetView<SurahDetailController> {
  const SurahView({super.key});

  _QuranThemeData _getTheme(int themeIndex) {
    switch (themeIndex) {
      case 1: // Pure White
        return const _QuranThemeData(
          backgroundColor: Color(0xFFF8FAFC),
          pageSurface: Colors.white,
          textColor: Color(0xFF0F172A),
          ayahNumberColor: Color(0xFF047857),
          accentColor: Color(0xFF059669),
          appBarColor: Colors.white,
          borderColor: Color(0xFFE2E8F0),
          isDark: false,
        );
      case 2: // Dark Mode
        return const _QuranThemeData(
          backgroundColor: Color(0xFF111215),
          pageSurface: Color(0xFF1B1D22),
          textColor: Color(0xFFE2E8F0),
          ayahNumberColor: Color(0xFFF59E0B),
          accentColor: Color(0xFFF59E0B),
          appBarColor: Color(0xFF16181D),
          borderColor: Color(0xFF2D3139),
          isDark: true,
        );
      case 0: // Warm Sepia / Mushaf Cream (Default)
      default:
        return const _QuranThemeData(
          backgroundColor: Color(0xFFFAF6EB),
          pageSurface: Color(0xFFFFFDF8),
          textColor: Color(0xFF1E293B),
          ayahNumberColor: Color(0xFF0D9488),
          accentColor: Color(0xFFB45309),
          appBarColor: Color(0xFFF6F0E0),
          borderColor: Color(0xFFEADBC8),
          isDark: false,
        );
    }
  }

  void _showSettingsBottomSheet(
    BuildContext context,
    _QuranThemeData theme,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.pageSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Obx(() {
          final currentSize = controller.fontSize.value;
          final currentTheme = controller.readingThemeIndex.value;
          final isMushaf = controller.isMushafMode.value;

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Sheet Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "خيارات القراءة والمصحف",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppStrings.fontCairo,
                        color: theme.textColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: theme.textColor),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Theme Mode Selector
                Text(
                  "نمط القراءة واللون:",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppStrings.fontCairo,
                    color: theme.textColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Sepia Option
                    Expanded(
                      child: _buildThemeChoiceChip(
                        title: "ورق عاجي",
                        isSelected: currentTheme == 0,
                        previewBg: const Color(0xFFFAF6EB),
                        previewBorder: const Color(0xFFB45309),
                        onTap: () => controller.setReadingTheme(0),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // White Option
                    Expanded(
                      child: _buildThemeChoiceChip(
                        title: "ناصع البياض",
                        isSelected: currentTheme == 1,
                        previewBg: Colors.white,
                        previewBorder: const Color(0xFF059669),
                        onTap: () => controller.setReadingTheme(1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Dark Option
                    Expanded(
                      child: _buildThemeChoiceChip(
                        title: "قراءة ليلية",
                        isSelected: currentTheme == 2,
                        previewBg: const Color(0xFF181A1E),
                        previewBorder: const Color(0xFFF59E0B),
                        onTap: () => controller.setReadingTheme(2),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Display Mode (Mushaf flow vs Verse cards)
                Text(
                  "طريقة عرض الآيات:",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppStrings.fontCairo,
                    color: theme.textColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (!isMushaf) controller.toggleMushafMode();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: isMushaf
                                ? theme.accentColor.withValues(alpha: 0.12)
                                : Colors.grey.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isMushaf
                                  ? theme.accentColor
                                  : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu_book_rounded,
                                size: 16,
                                color: isMushaf
                                    ? theme.accentColor
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "المصحف المتصل",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppStrings.fontCairo,
                                  color: isMushaf
                                      ? theme.accentColor
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (isMushaf) controller.toggleMushafMode();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: !isMushaf
                                ? theme.accentColor.withValues(alpha: 0.12)
                                : Colors.grey.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: !isMushaf
                                  ? theme.accentColor
                                  : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.view_agenda_rounded,
                                size: 16,
                                color: !isMushaf
                                    ? theme.accentColor
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "آية تلو آية",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppStrings.fontCairo,
                                  color: !isMushaf
                                      ? theme.accentColor
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Font Size Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "حجم الخط القرآني:",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppStrings.fontCairo,
                        color: theme.textColor.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      "${currentSize.toInt()} نقطة",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppStrings.fontCairo,
                        color: theme.accentColor,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                      color: theme.accentColor,
                      onPressed: controller.decreaseFontSize,
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(ctx).copyWith(
                          activeTrackColor: theme.accentColor,
                          inactiveTrackColor:
                              theme.accentColor.withValues(alpha: 0.2),
                          thumbColor: theme.accentColor,
                          overlayColor:
                              theme.accentColor.withValues(alpha: 0.15),
                        ),
                        child: Slider(
                          value: currentSize,
                          min: 18,
                          max: 38,
                          divisions: 10,
                          onChanged: (val) => controller.setFontSize(val),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      color: theme.accentColor,
                      onPressed: controller.increaseFontSize,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildThemeChoiceChip({
    required String title,
    required bool isSelected,
    required Color previewBg,
    required Color previewBorder,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: previewBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? previewBorder : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            fontFamily: AppStrings.fontCairo,
            color: isSelected ? previewBorder : Colors.grey.shade700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _copyAyah(BuildContext context, String text, int ayahNum) {
    Clipboard.setData(
      ClipboardData(
        text: '$text ﴿$ayahNum﴾ [سورة ${controller.surahTitle}]',
      ),
    );
    HapticFeedback.selectionClick();
    Get.rawSnackbar(
      messageText: const Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text(
            "تم نسخ الآية الكريمة بنجاح",
            style: TextStyle(
              fontFamily: AppStrings.fontCairo,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1E293B),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeIndex = controller.readingThemeIndex.value;
      final theme = _getTheme(themeIndex);
      final fontSize = controller.fontSize.value;
      final isMushaf = controller.isMushafMode.value;

      return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: theme.textColor,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "سُورَةُ ${controller.surahTitle}",
            style: TextStyle(
              fontFamily: AppStrings.fontAmiri,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: theme.textColor,
            ),
          ),
          actions: [
            // Bookmark Action Button (الانتقال إلى الفاصل)
            Obx(() {
              final b = controller.bookmark.value;
              final isInThisSurah =
                  b != null && b.surahNumber == controller.surahNumber;
              final hasAnyBookmark = b != null;

              return IconButton(
                tooltip: hasAnyBookmark
                    ? "الانتقال إلى الفاصل (${b.surahName} - آية ${b.ayahNumber}) 🔖"
                    : "الانتقال إلى الفاصل 🔖",
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      hasAnyBookmark
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      size: 22,
                      color: isInThisSurah
                          ? const Color(0xFFD97706)
                          : hasAnyBookmark
                              ? theme.accentColor
                              : theme.textColor.withValues(alpha: 0.75),
                    ),
                    if (isInThisSurah)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => controller.jumpToBookmark(context),
              );
            }),
            // Quick Font Size -
            IconButton(
              tooltip: "تصغير الخط",
              icon: Text(
                "A-",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontFamily: AppStrings.fontCairo,
                  color: theme.textColor.withValues(alpha: 0.8),
                ),
              ),
              onPressed: controller.decreaseFontSize,
            ),
            // Quick Font Size +
            IconButton(
              tooltip: "تكبير الخط",
              icon: Text(
                "A+",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: AppStrings.fontCairo,
                  color: theme.textColor.withValues(alpha: 0.8),
                ),
              ),
              onPressed: controller.increaseFontSize,
            ),
            // Settings Bottom Sheet
            IconButton(
              tooltip: "إعدادات القراءة",
              icon: Icon(
                Iconsax.setting_4,
                size: 20,
                color: theme.textColor,
              ),
              onPressed: () => _showSettingsBottomSheet(context, theme),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Main Quran Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.accentColor,
                      ),
                    );
                  }

                  if (controller.errorMessage.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.errorMessage.value,
                              style: TextStyle(
                                fontFamily: AppStrings.fontCairo,
                                color: theme.textColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.accentColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: controller.loadVerses,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView(
                      controller: controller.scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      children: [
                        // Ornate Surah Header Banner
                        _buildSurahHeaderCard(theme),

                        const SizedBox(height: 14),

                        // Bookmark Quick Jump Banner if set in this surah
                        _buildCurrentSurahBookmarkBanner(theme),

                        // Basmala Banner (for all except At-Tawbah & Al-Fatihah)
                        if (controller.surahNumber != 9 &&
                            controller.surahNumber != 1)
                          _buildBasmalaBanner(theme),

                        if (controller.surahNumber != 9 &&
                            controller.surahNumber != 1)
                          const SizedBox(height: 14),

                        // Quranic Verses Display (Mushaf Flow or Verse-by-Verse)
                        if (isMushaf)
                          _buildMushafFlowView(context, theme, fontSize)
                        else
                          _buildVerseByVerseView(context, theme, fontSize),

                        const SizedBox(height: 20),

                        // Bottom Navigation Between Surahs
                        _buildSurahNavigator(theme),

                        const SizedBox(height: 14),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Ornate Surah Information Cartouche (Header)
  Widget _buildSurahHeaderCard(_QuranThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.pageSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Decorative Ornate Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "❖  سُورَةُ ${controller.surahTitle}  ❖",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppStrings.fontAmiri,
                  color: theme.accentColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Metadata Chips Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadgeChip(
                "رقمها: ${controller.surahNumber}",
                theme,
              ),
              const SizedBox(width: 8),
              _buildBadgeChip(
                controller.surahType.value,
                theme,
              ),
              const SizedBox(width: 8),
              _buildBadgeChip(
                "${controller.totalVerses.value} آية",
                theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeChip(String text, _QuranThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: theme.accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.accentColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
          fontFamily: AppStrings.fontCairo,
          color: theme.accentColor,
        ),
      ),
    );
  }

  // The Basmala Calligraphy Banner
  Widget _buildBasmalaBanner(_QuranThemeData theme) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: theme.pageSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.borderColor),
        ),
        child: Text(
          "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
          style: TextStyle(
            fontSize: 22,
            fontFamily: AppStrings.fontAmiri,
            fontWeight: FontWeight.bold,
            color: theme.accentColor,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Continuous Mushaf Flow Mode (Classic Mushaf Page)
  Widget _buildMushafFlowView(
    BuildContext context,
    _QuranThemeData theme,
    double fontSize,
  ) {
    return Obx(() {
      final List<InlineSpan> spans = [];
      final activeBookmark = controller.bookmark.value;
      final highlighted = controller.highlightedAyah.value;

      for (final a in controller.verses) {
        final isBookmarked =
            activeBookmark != null &&
            activeBookmark.surahNumber == controller.surahNumber &&
            activeBookmark.ayahNumber == a.ayah;
        final isHighlighted = highlighted == a.ayah;

        Color? bgHighlight;
        if (isHighlighted) {
          bgHighlight = const Color(0x66F59E0B);
        } else if (isBookmarked) {
          bgHighlight =
              theme.isDark
                  ? const Color(0x3DF59E0B)
                  : const Color(0x28F59E0B);
        }

        // Invisible precise anchor at the start of the ayah for pixel-exact scrolling
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox(
              key: controller.getAyahKey(a.ayah),
              width: 0.1,
              height: 1.0,
            ),
          ),
        );

        spans.add(
          TextSpan(
            text: '${a.text.trim()} ',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: AppStrings.fontAmiri,
              height: 2.15,
              color:
                  isBookmarked
                      ? (theme.isDark
                          ? const Color(0xFFFDE68A)
                          : const Color(0xFFB45309))
                      : theme.textColor,
              backgroundColor: bgHighlight,
              fontWeight: isBookmarked ? FontWeight.w600 : FontWeight.normal,
              letterSpacing: 0.2,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () => _showAyahOptionsSheet(context, a, theme),
          ),
        );

        // Ornate Bookmark Indicator Pill in Mushaf flow!
        if (isBookmarked) {
          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () => _showAyahOptionsSheet(context, a, theme),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD97706), Color(0xFFB45309)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33D97706),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bookmark_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(width: 3),
                      Text(
                        "فاصل",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppStrings.fontCairo,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        spans.add(
          TextSpan(
            text: ' ﴿${a.ayah}﴾ ',
            style: TextStyle(
              fontSize: fontSize * 0.85,
              fontFamily: AppStrings.fontAmiri,
              color:
                  isBookmarked
                      ? const Color(0xFFD97706)
                      : theme.ayahNumberColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () => _showAyahOptionsSheet(context, a, theme),
          ),
        );
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: theme.pageSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.isDark ? 0.3 : 0.03),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: RichText(
          text: TextSpan(children: spans),
          textAlign: TextAlign.justify,
        ),
      );
    });
  }

  // Current Surah Bookmark Quick Jump Banner
  Widget _buildCurrentSurahBookmarkBanner(_QuranThemeData theme) {
    return Obx(() {
      final b = controller.bookmark.value;
      if (b == null || b.surahNumber != controller.surahNumber) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.scrollToAyah(b.ayahNumber, highlight: true),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFD97706).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bookmark_rounded,
                      size: 18,
                      color: Color(0xFFD97706),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "فاصل القراءة الحالي",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF92400E),
                            fontFamily: AppStrings.fontCairo,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "وصلت عند الآية (${b.ayahNumber}) في سورة ${b.surahName}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppStrings.fontCairo,
                            color: theme.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD97706),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "انتقال للآية",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppStrings.fontCairo,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_downward_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // Verse-by-Verse Card Mode
  Widget _buildVerseByVerseView(
    BuildContext context,
    _QuranThemeData theme,
    double fontSize,
  ) {
    return Obx(() {
      final activeBookmark = controller.bookmark.value;
      final highlighted = controller.highlightedAyah.value;

      return Column(
        children:
            controller.verses.map((ayah) {
              final isBookmarked =
                  activeBookmark != null &&
                  activeBookmark.surahNumber == controller.surahNumber &&
                  activeBookmark.ayahNumber == ayah.ayah;
              final isHighlighted = highlighted == ayah.ayah;

              return Container(
                key: controller.getAyahKey(ayah.ayah),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isHighlighted
                          ? const Color(0xFFF59E0B).withValues(alpha: 0.18)
                          : (isBookmarked
                              ? const Color(0xFFF59E0B).withValues(alpha: 0.08)
                              : theme.pageSurface),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isBookmarked
                            ? const Color(0xFFF59E0B)
                            : (isHighlighted
                                ? const Color(0xFFF59E0B)
                                : theme.borderColor),
                    width: isBookmarked || isHighlighted ? 1.8 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isBookmarked
                              ? const Color(0xFFF59E0B).withValues(alpha: 0.12)
                              : Colors.black.withValues(
                                alpha: theme.isDark ? 0.2 : 0.02,
                              ),
                      blurRadius: isBookmarked ? 10 : 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bookmark Badge inside card if set
                    if (isBookmarked)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(
                              0xFFF59E0B,
                            ).withValues(alpha: 0.35),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bookmark_rounded,
                              size: 15,
                              color: Color(0xFFD97706),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "فاصل القراءة الحالي 🔖",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppStrings.fontCairo,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Card Top: Ayah Number & Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isBookmarked
                                    ? const Color(
                                      0xFFF59E0B,
                                    ).withValues(alpha: 0.2)
                                    : theme.ayahNumberColor.withValues(
                                      alpha: 0.1,
                                    ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "الآية ${ayah.ayah}",
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppStrings.fontCairo,
                              color:
                                  isBookmarked
                                      ? const Color(0xFFD97706)
                                      : theme.ayahNumberColor,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Bookmark Toggle Button
                            IconButton(
                              tooltip:
                                  isBookmarked
                                      ? "الفاصل محفوظ هنا (اضغط للإزالة)"
                                      : "وضع فاصل القراءة هنا",
                              icon: Icon(
                                isBookmarked
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_outline_rounded,
                                size: 20,
                                color:
                                    isBookmarked
                                        ? const Color(0xFFD97706)
                                        : theme.textColor.withValues(
                                          alpha: 0.45,
                                        ),
                              ),
                              onPressed: () => controller.toggleBookmark(ayah),
                            ),
                            // Share Ayah Button
                            IconButton(
                              tooltip: "مشاركة الآية",
                              icon: Icon(
                                Icons.share_rounded,
                                size: 18,
                                color: theme.textColor.withValues(alpha: 0.45),
                              ),
                              onPressed: () => controller.shareAyah(ayah),
                            ),
                            // Copy Ayah Button
                            IconButton(
                              tooltip: "نسخ الآية",
                              icon: Icon(
                                Iconsax.copy,
                                size: 18,
                                color: theme.textColor.withValues(alpha: 0.45),
                              ),
                              onPressed:
                                  () => _copyAyah(
                                    context,
                                    ayah.text,
                                    ayah.ayah,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Ayah Text
                    SelectableText(
                      ayah.text.trim(),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: AppStrings.fontAmiri,
                        height: 2.1,
                        color:
                            isBookmarked
                                ? (theme.isDark
                                    ? const Color(0xFFFDE68A)
                                    : const Color(0xFFB45309))
                                : theme.textColor,
                        fontWeight:
                            isBookmarked ? FontWeight.w600 : FontWeight.normal,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              );
            }).toList(),
      );
    });
  }

  // Bottom Sheet for Ayah interaction in Mushaf mode
  void _showAyahOptionsSheet(
    BuildContext context,
    AyahModel ayah,
    _QuranThemeData theme,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.pageSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Obx(() {
          final isBookmarked = controller.isAyahBookmarked(ayah.ayah);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "سورة ${controller.surahTitle} • الآية (${ayah.ayah})",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppStrings.fontCairo,
                          color: theme.textColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        color: theme.textColor.withValues(alpha: 0.6),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Ayah Preview Quote
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.accentColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.accentColor.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      "﴿ ${ayah.text.trim()} ﴾",
                      style: TextStyle(
                        fontFamily: AppStrings.fontAmiri,
                        fontSize: 16.5,
                        height: 1.8,
                        color: theme.textColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Option 1: Bookmark
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isBookmarked
                            ? Icons.bookmark_remove_rounded
                            : Icons.bookmark_add_rounded,
                        color: const Color(0xFFD97706),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      isBookmarked
                          ? "إزالة فاصل القراءة عن هذه الآية"
                          : "وضع فاصل القراءة عند هذه الآية 🔖",
                      style: TextStyle(
                        fontFamily: AppStrings.fontCairo,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color:
                            isBookmarked
                                ? Colors.red.shade700
                                : theme.textColor,
                      ),
                    ),
                    subtitle: Text(
                      isBookmarked
                          ? "اضغط لإزالة الفاصل من هذا الموضع"
                          : "لحفظ مكان توقفك والرجوع إليه لاحقًا بزر واحد",
                      style: TextStyle(
                        fontFamily: AppStrings.fontCairo,
                        fontSize: 11.5,
                        color: theme.textColor.withValues(alpha: 0.6),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      controller.toggleBookmark(ayah);
                    },
                  ),

                  // Option 2: Copy
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Iconsax.copy,
                        color: theme.accentColor,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      "نسخ الآية الكريمة",
                      style: TextStyle(
                        fontFamily: AppStrings.fontCairo,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: theme.textColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _copyAyah(context, ayah.text, ayah.ayah);
                    },
                  ),

                  // Option 3: Share
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34C759).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.share_rounded,
                        color: Color(0xFF34C759),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      "مشاركة الآية",
                      style: TextStyle(
                        fontFamily: AppStrings.fontCairo,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: theme.textColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      controller.shareAyah(ayah);
                    },
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // Bottom Surah Navigation Bar (Next & Previous Surah)
  Widget _buildSurahNavigator(_QuranThemeData theme) {
    final hasPrev = controller.hasPreviousSurah;
    final hasNext = controller.hasNextSurah;

    final prevName = hasPrev
        ? SurahModel.allSurahs[controller.surahNumber - 2].name
        : '';
    final nextName = hasNext
        ? SurahModel.allSurahs[controller.surahNumber].name
        : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.pageSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Surah Button
          if (hasPrev)
            TextButton.icon(
              onPressed: controller.goToPreviousSurah,
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              label: Text(
                "سورة $prevName",
                style: TextStyle(
                  fontFamily: AppStrings.fontCairo,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.accentColor,
                ),
              ),
            )
          else
            const SizedBox(width: 80),

          // Surah Order Indicator
          Text(
            "${controller.surahNumber} / 114",
            style: TextStyle(
              fontSize: 12,
              fontFamily: AppStrings.fontCairo,
              fontWeight: FontWeight.bold,
              color: theme.textColor.withValues(alpha: 0.6),
            ),
          ),

          // Next Surah Button
          if (hasNext)
            TextButton.icon(
              onPressed: controller.goToNextSurah,
              label: Text(
                "سورة $nextName",
                style: TextStyle(
                  fontFamily: AppStrings.fontCairo,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.accentColor,
                ),
              ),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
            )
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }
}
