import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/splash/controllers/splash_controller.dart';
import '../features/splash/views/splash_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SplashController>()) {
      Get.lazyPut<SplashController>(() => SplashController());
    }
    return const SplashView();
  }
}
