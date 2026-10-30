import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/surah_detail_controller.dart';
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
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      children: [
                        // Ornate Surah Header Banner
                        _buildSurahHeaderCard(theme),

                        const SizedBox(height: 14),

                        // Basmala Banner (for all except At-Tawbah & Al-Fatihah)
                        if (controller.surahNumber != 9 &&
                            controller.surahNumber != 1)
                          _buildBasmalaBanner(theme),

                        if (controller.surahNumber != 9 &&
                            controller.surahNumber != 1)
                          const SizedBox(height: 14),

                        // Quranic Verses Display (Mushaf Flow or Verse-by-Verse)
                        if (isMushaf)
                          _buildMushafFlowView(theme, fontSize)
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
  Widget _buildMushafFlowView(_QuranThemeData theme, double fontSize) {
    final List<InlineSpan> spans = [];

    for (final a in controller.verses) {
      spans.add(
        TextSpan(
          text: '${a.text.trim()} ',
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: AppStrings.fontAmiri,
            height: 2.15,
            color: theme.textColor,
            letterSpacing: 0.2,
          ),
        ),
      );
      spans.add(
        TextSpan(
          text: ' ﴿${a.ayah}﴾ ',
          style: TextStyle(
            fontSize: fontSize * 0.85,
            fontFamily: AppStrings.fontAmiri,
            color: theme.ayahNumberColor,
            fontWeight: FontWeight.bold,
          ),
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
  }

  // Verse-by-Verse Card Mode
  Widget _buildVerseByVerseView(
    BuildContext context,
    _QuranThemeData theme,
    double fontSize,
  ) {
    return Column(
      children: controller.verses.map((ayah) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.pageSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: theme.isDark ? 0.2 : 0.02,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Top: Ayah Number & Quick Copy Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: theme.ayahNumberColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "الآية ${ayah.ayah}",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppStrings.fontCairo,
                        color: theme.ayahNumberColor,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: "نسخ الآية",
                    icon: Icon(
                      Iconsax.copy,
                      size: 18,
                      color: theme.textColor.withValues(alpha: 0.5),
                    ),
                    onPressed: () => _copyAyah(context, ayah.text, ayah.ayah),
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
                  color: theme.textColor,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        );
      }).toList(),
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
