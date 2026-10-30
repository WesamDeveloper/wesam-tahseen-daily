import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../adhkar/views/prayers_view.dart';
import '../../quran/views/quran_view.dart';
import '../../quran_audio/views/quran_audio_view.dart';
import '../../settings/views/settings_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/custom_motion_tab_bar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.ltr,
        child: CustomMotionTabBar(
          controller: controller.motionTabBarController,
          initialSelectedTab: AppStrings.tabPrayers,
          labels: const [
            AppStrings.tabPrayers,
            AppStrings.tabQuran,
            AppStrings.tabQuranAudio,
            AppStrings.tabSettings,
          ],
          tabItemBuilders: [
            (color, size) => Icon(Icons.mosque, color: color, size: size),
            (color, size) =>
                Icon(Icons.menu_book_rounded, color: color, size: size),
            (color, size) => SvgPicture.asset(
              AppAssets.quranAudioSvg,
              width: size,
              height: size,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            (color, size) =>
                Icon(Icons.settings_rounded, color: color, size: size),
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
            controller.changeTab(value);
          },
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.motionTabBarController,
        children: const <Widget>[
          Center(child: PrayersView()),
          Center(child: QuranView()),
          Center(child: QuranAudioView()),
          Center(child: SettingsView()),
        ],
      ),
    );
  }
}
