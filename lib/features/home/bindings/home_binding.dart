import 'package:get/get.dart';
import '../../about/controllers/about_controller.dart';
import '../../quran/controllers/quran_controller.dart';
import '../../quran/repositories/quran_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<QuranRepository>(() => QuranRepository());
    Get.lazyPut<QuranController>(
      () => QuranController(repository: Get.find<QuranRepository>()),
    );
    Get.lazyPut<AboutController>(() => AboutController());
  }
}
