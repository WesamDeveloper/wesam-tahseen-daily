import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/about_controller.dart';
import '../widgets/contact_tile.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(AppStrings.aboutTitle),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage(AppAssets.profile),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'وسام الجنيد',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'مبرمج تقنية معلومات - متخصص في Flutter',
                style: TextStyle(fontSize: 18, color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'أنا وسام الجنيد، مطوّر تطبيقات ومبرمج في مجال تقنية المعلومات. أُتقن تطوير تطبيقات باستخدام Flutter مع التركيز على تصميم جذاب وتجربة مستخدم مثالية. أهدف إلى تقديم حلول ذكية ومبتكرة تلبي احتياجات المستخدمين وتحقق أداء عالي. شغوف بالتطوير المستمر والابتكار.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      fontFamily: AppStrings.fontCairo,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  ContactTile(
                    icon: Icons.phone,
                    title: '+967775904988',
                    onTap: () => controller.launchPhone('+967775904988'),
                  ),
                  const SizedBox(height: 8),
                  ContactTile(
                    icon: Icons.email,
                    title: 'ws531014@gmail.com',
                    onTap: () => controller.launchEmail('ws531014@gmail.com'),
                  ),
                  const SizedBox(height: 8),
                  ContactTile(
                    icon: Icons.code,
                    title: 'github.com/WesamTechnology',
                    onTap:
                        () => controller.launchWeb(
                          'https://github.com/WesamTechnology',
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
