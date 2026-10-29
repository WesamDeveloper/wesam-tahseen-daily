import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/adhkar_controller.dart';
import '../models/zikr_category.dart';
import '../widgets/zikr_finished_summary.dart';
import '../widgets/zikr_item_card.dart';

class ZikrDetailView extends GetView<AdhkarController> {
  const ZikrDetailView({super.key});

  String _getTitle(ZikrCategoryType type) {
    switch (type) {
      case ZikrCategoryType.sabh:
        return AppStrings.sabhTitle;
      case ZikrCategoryType.masi:
        return AppStrings.masiTitle;
      case ZikrCategoryType.sleep:
        return AppStrings.sleepTitle;
      case ZikrCategoryType.safer:
        return AppStrings.saferTitle;
      case ZikrCategoryType.alham:
        return AppStrings.alhamTitle;
      case ZikrCategoryType.tasbeeh:
        return AppStrings.tasbeehTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categoryType = controller.currentCategoryType.value;
      final title = _getTitle(categoryType);
      final isFinished = controller.isFinished;
      final textFont = controller.textFont.value.toDouble();

      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              fontFamily: AppStrings.fontRakkas,
            ),
          ),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: controller.decreaseFontSize,
                  child: const SizedBox(
                    width: 40,
                    child: Text(
                      "ض",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: AppStrings.fontRakkas,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.increaseFontSize,
                  child: const SizedBox(
                    width: 40,
                    child: Text(
                      "ض",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        fontFamily: AppStrings.fontRakkas,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.islamicPattern),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child:
                      isFinished
                          ? const SizedBox.shrink()
                          : ListView.builder(
                            itemCount: controller.azkarList.length,
                            itemBuilder: (context, index) {
                              final item = controller.azkarList[index];
                              return ZikrItemCard(
                                text: item.text,
                                count: item.count,
                                fontSize: textFont,
                                onTap: () => controller.onTapItem(index),
                              );
                            },
                          ),
                ),
                if (isFinished)
                  ZikrFinishedSummary(
                    currentReadCount: controller.currentReadCount.value,
                    totalReadCount: controller.totalReadCount.value,
                    onBack: () => Get.back(),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
