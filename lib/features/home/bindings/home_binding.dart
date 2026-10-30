import 'package:get/get.dart';
import '../../about/controllers/about_controller.dart';
import '../../quran/controllers/quran_controller.dart';
import '../../quran/repositories/quran_repository.dart';
import '../../quran_audio/controllers/quran_audio_controller.dart';
import '../../quran_audio/services/quran_audio_service.dart';
import '../../settings/controllers/notification_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<QuranRepository>(() => QuranRepository());
    Get.lazyPut<QuranController>(
      () => QuranController(repository: Get.find<QuranRepository>()),
    );
    Get.lazyPut<QuranAudioService>(() => QuranAudioService());
    Get.lazyPut<QuranAudioController>(
      () => QuranAudioController(audioService: Get.find<QuranAudioService>()),
    );
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<AboutController>(() => AboutController());
  }
}
