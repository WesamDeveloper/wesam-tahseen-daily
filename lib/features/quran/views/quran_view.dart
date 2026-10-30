import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/quran_controller.dart';
import '../widgets/surah_tile.dart';

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuranController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F2),
      appBar: AppBar(
        title: const Text(
          AppStrings.quranTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppStrings.fontCairo,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Quran Banner & Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                children: [
                  // Quran Inspirational Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFF7ED),
                          Color(0xFFFEF3C7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.22),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 18,
                          color: Color(0xFF92400E),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "﴿ إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ ﴾",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontFamily: AppStrings.fontAmiri,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Search Bar
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: controller.filterSurahs,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: AppStrings.fontCairo,
                        fontSize: 13.5,
                      ),
                      decoration: InputDecoration(
                        hintText: "ابحث عن سورة (مثال: الكهف، البقرة)...",
                        hintStyle: TextStyle(
                          fontFamily: AppStrings.fontCairo,
                          fontSize: 12.5,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: const Icon(
                          Iconsax.search_normal_1,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  controller.filterSurahs('');
                                  setState(() {});
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Surahs List
            Expanded(
              child: Obx(() {
                final list = controller.filteredSurahs;

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.search_status,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "لا توجد سورة مطابقة لبحثك",
                          style: TextStyle(
                            fontFamily: AppStrings.fontCairo,
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: list.length,
                  itemBuilder: (ctx, i) {
                    final surah = list[i];
                    return SurahTile(
                      surah: surah,
                      onTap: () => controller.onSelectSurah(surah),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
