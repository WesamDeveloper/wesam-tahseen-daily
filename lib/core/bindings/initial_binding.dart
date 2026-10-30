import 'package:get/get.dart';
import '../notifications/notification_service.dart';
import '../services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<StorageService>(
      () async => await StorageService().init(),
      permanent: true,
    );
    Get.putAsync<NotificationService>(
      () async => await NotificationService().init(),
      permanent: true,
    );
  }
}
