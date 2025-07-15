import 'package:dene/screen/prayers.dart';
//import 'package:dene/screen/quranPage.dart';
import 'package:dene/screen/quran_page.dart';
import 'package:dene/screen/settings.dart';
import 'package:dene/screen/study.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionBadgeWidget.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:motion_tab_bar/MotionTabItem.dart';
import 'package:motion_tab_bar/helpers/HalfClipper.dart';
import 'package:motion_tab_bar/helpers/HalfPainter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // TabController _tabController;
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();

    //// Use normal tab controller
    // _tabController = TabController(
    //   initialIndex: 1,
    //   length: 4,
    //   vsync: this,
    // );

    //// use "MotionTabBarController" to replace with "TabController", if you need to programmatically change the tab
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();

    // _tabController.dispose();
    _motionTabBarController!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController, // ADD THIS if you need to change your tab programmatically
        initialSelectedTab: "Prayers",
        labels: const ["Prayers", "Quran"],
        icons: const [
         // Icons.home,
          Icons.mosque, // Using a mosque icon for prayers
          Icons.book, // Using a book icon for Quran
         // Icons.settings
        ],

        // optional badges, length must be same with labels

        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.orange[400],
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Colors.orange[800],
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            // _tabController!.index = value;
            _motionTabBarController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        // controller: _tabController,
        controller: _motionTabBarController,
        children: <Widget>[
          // const Center(
          //   child: Study(),
          // ),
          const Center(
            child: Prayers(),
          ),
          const Center(
            child: QuranPage(),
          ),
          // const Center(
          //   child: Settings(),
          // ),
        ],
      ),
    );
  }
}
