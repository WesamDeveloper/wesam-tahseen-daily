import 'package:get/get.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final MotionTabBarController motionTabBarController;
  final RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
    motionTabBarController.index = index;
  }

  @override
  void onClose() {
    motionTabBarController.dispose();
    super.onClose();
  }
}
