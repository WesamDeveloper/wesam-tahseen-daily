import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../models/zikr_category.dart';
import '../widgets/islamic_card.dart';

class PrayersView extends StatelessWidget {
  const PrayersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.prayersTitle),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.islamicPattern),
            fit: BoxFit.cover,
            opacity: 0.7,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 70),
                    const Text(
                      AppStrings.bismillah,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ...ZikrCategory.categories.map((cat) {
                      return IslamicCard(
                        title: cat.title,
                        icon: cat.icon,
                        color: cat.color,
                        onTap: () {
                          if (cat.type == ZikrCategoryType.tasbeeh) {
                            Get.toNamed(AppRoutes.tasbeeh);
                          } else {
                            Get.toNamed(
                              AppRoutes.zikrDetail,
                              arguments: cat.type,
                            );
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  AppStrings.duaFooter,
                  style: TextStyle(fontSize: 14, color: AppColors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
