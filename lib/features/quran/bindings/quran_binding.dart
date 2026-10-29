import 'package:get/get.dart';
import '../controllers/quran_controller.dart';
import '../repositories/quran_repository.dart';

class QuranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranRepository>(() => QuranRepository());
    Get.lazyPut<QuranController>(
      () => QuranController(repository: Get.find<QuranRepository>()),
    );
  }
}
