import 'package:get/get.dart';
import '../controllers/quran_audio_controller.dart';
import '../services/quran_audio_service.dart';

class QuranAudioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranAudioService>(() => QuranAudioService());
    Get.lazyPut<QuranAudioController>(
      () => QuranAudioController(audioService: Get.find<QuranAudioService>()),
    );
  }
}
