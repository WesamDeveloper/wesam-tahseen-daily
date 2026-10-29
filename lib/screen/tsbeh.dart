import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/adhkar/controllers/tasbeeh_controller.dart';
import '../features/adhkar/views/tasbeeh_view.dart';

class TsbehPage extends StatelessWidget {
  const TsbehPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TasbeehController>()) {
      Get.lazyPut<TasbeehController>(() => TasbeehController());
    }
    return const TasbeehView();
  }
}
