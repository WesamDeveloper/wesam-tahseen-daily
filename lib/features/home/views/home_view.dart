import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../about/views/about_view.dart';
import '../../adhkar/views/prayers_view.dart';
import '../../quran/views/quran_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: controller.motionTabBarController,
        initialSelectedTab: AppStrings.tabPrayers,
        labels: const [
          AppStrings.tabPrayers,
          AppStrings.tabQuran,
          AppStrings.tabAbout,
        ],
        icons: const [Icons.mosque, Icons.book, Icons.person],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: AppColors.primary,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: AppColors.primaryDeep,
        tabIconSelectedColor: AppColors.white,
        tabBarColor: AppColors.white,
        onTabItemSelected: (int value) {
          controller.changeTab(value);
        },
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.motionTabBarController,
        children: const <Widget>[
          Center(child: PrayersView()),
          Center(child: QuranView()),
          Center(child: AboutView()),
        ],
      ),
    );
  }
}
