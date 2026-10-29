import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../features/adhkar/controllers/adhkar_controller.dart';
import '../../features/adhkar/models/zikr_category.dart';
import '../../features/adhkar/repositories/adhkar_repository.dart';
import '../../features/adhkar/views/zikr_detail_view.dart';

class Safer extends StatelessWidget {
  const Safer({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdhkarRepository>()) {
      Get.lazyPut<AdhkarRepository>(
        () => AdhkarRepository(storageService: Get.find<StorageService>()),
      );
    }
    Get.delete<AdhkarController>();
    final controller = Get.put<AdhkarController>(
      AdhkarController(repository: Get.find<AdhkarRepository>()),
    );
    controller.setCategory(ZikrCategoryType.safer);
    return const ZikrDetailView();
  }
}
