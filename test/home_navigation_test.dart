import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dene/core/constants/app_assets.dart';
import 'package:dene/core/constants/app_colors.dart';
import 'package:dene/core/constants/app_strings.dart';
import 'package:dene/core/constants/storage_keys.dart';
import 'package:dene/core/services/storage_service.dart';
import 'package:dene/features/home/controllers/home_controller.dart';
import 'package:dene/features/home/widgets/custom_motion_tab_bar.dart';
import 'package:dene/features/quran_audio/controllers/quran_audio_controller.dart';
import 'package:dene/features/quran_audio/services/quran_audio_service.dart';
import 'package:dene/features/quran_audio/views/quran_audio_view.dart';
import 'quran_audio_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({StorageKeys.totalRead: 10});
    final storageService = StorageService();
    await storageService.init();
    Get.put<StorageService>(storageService, permanent: true);

    Get.put<HomeController>(HomeController());
    Get.put<QuranAudioService>(FakeQuranAudioService());
    Get.put<QuranAudioController>(
      QuranAudioController(audioService: Get.find<QuranAudioService>()),
    );
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('QuranAudioView renders all audio widgets correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: QuranAudioView()));
    await tester.pump();

    // Verify App Bar Title
    expect(find.text(AppStrings.quranAudioTitle), findsOneWidget);

    // Verify Reciter info & current surah
    expect(find.text(AppStrings.reciterName), findsWidgets);
    expect(find.text('سورة الفاتحة'), findsWidgets);

    // Verify Controls
    expect(find.byIcon(Icons.play_arrow_rounded), findsWidgets);
    expect(find.byIcon(Icons.skip_next_rounded), findsOneWidget);
    expect(find.byIcon(Icons.skip_previous_rounded), findsOneWidget);
    expect(find.byIcon(Icons.forward_10_rounded), findsOneWidget);
    expect(find.byIcon(Icons.replay_10_rounded), findsOneWidget);

    // Verify Search Bar
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text(AppStrings.searchSurahHint), findsOneWidget);

    // Search for a specific surah
    await tester.enterText(find.byType(TextField), 'البقرة');
    await tester.pump();

    expect(find.text('سورة البقرة'), findsWidgets);
  });

  testWidgets(
    'CustomMotionTabBar renders 4 tabs with SVG icon for Quran Audio',
    (WidgetTester tester) async {
      final homeController = Get.find<HomeController>();
      expect(homeController.motionTabBarController.length, 4);

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            bottomNavigationBar: Directionality(
              textDirection: TextDirection.ltr,
              child: CustomMotionTabBar(
                controller: homeController.motionTabBarController,
                initialSelectedTab: AppStrings.tabPrayers,
                labels: const [
                  AppStrings.tabPrayers,
                  AppStrings.tabQuran,
                  AppStrings.tabQuranAudio,
                  AppStrings.tabAbout,
                ],
                tabItemBuilders: [
                  (color, size) =>
                      Icon(Icons.mosque, color: color, size: size),
                  (color, size) =>
                      Icon(Icons.menu_book_rounded, color: color, size: size),
                  (color, size) => SvgPicture.asset(
                    AppAssets.quranAudioSvg,
                    width: size,
                    height: size,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                  (color, size) =>
                      Icon(Icons.person, color: color, size: size),
                ],
                tabSize: 50,
                tabBarHeight: 55,
                textStyle: const TextStyle(
                  fontSize: 11,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                tabIconColor: AppColors.primary,
                tabIconSize: 26.0,
                tabIconSelectedSize: 26.0,
                tabSelectedColor: AppColors.primaryDeep,
                tabIconSelectedColor: AppColors.white,
                tabBarColor: AppColors.white,
                onTabItemSelected: (int value) {
                  homeController.changeTab(value);
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final tabBar = tester.widget<CustomMotionTabBar>(
        find.byType(CustomMotionTabBar),
      );
      expect(tabBar.labels.length, 4);
      expect(tabBar.labels, [
        AppStrings.tabPrayers,
        AppStrings.tabQuran,
        AppStrings.tabQuranAudio,
        AppStrings.tabAbout,
      ]);

      // Verify SVG is rendered for Quran Audio tab
      expect(find.byType(SvgPicture), findsWidgets);

      // Verify other tab icons
      expect(find.byIcon(Icons.mosque), findsWidgets);
      expect(find.byIcon(Icons.menu_book_rounded), findsWidgets);
      expect(find.byIcon(Icons.person), findsWidgets);

      // Test tab selection to tab 2 (Quran Audio)
      homeController.changeTab(2);
      await tester.pumpAndSettle();
      expect(homeController.currentTabIndex.value, 2);
    },
  );
}
