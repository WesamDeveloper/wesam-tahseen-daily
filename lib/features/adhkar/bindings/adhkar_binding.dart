import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../controllers/adhkar_controller.dart';
import '../repositories/adhkar_repository.dart';

class AdhkarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdhkarRepository>(
      () => AdhkarRepository(storageService: Get.find<StorageService>()),
    );
    Get.lazyPut<AdhkarController>(
      () => AdhkarController(repository: Get.find<AdhkarRepository>()),
    );
  }
}
