import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/tasbeeh_controller.dart';

class TasbeehView extends GetView<TasbeehController> {
  const TasbeehView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          AppStrings.tasbeehTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: AppStrings.fontRakkas,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              AppStrings.countTasbeeh,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Text(
                "${controller.counter.value}",
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: controller.increment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 50,
                ),
                backgroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                AppStrings.subhanAllahButton,
                style: TextStyle(fontSize: 28, color: AppColors.white),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: controller.reset,
              child: const Text(
                AppStrings.resetCounter,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
