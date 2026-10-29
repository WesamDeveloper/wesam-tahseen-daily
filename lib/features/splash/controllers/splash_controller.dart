import 'dart:async';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.home);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
