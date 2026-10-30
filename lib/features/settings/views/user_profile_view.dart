import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/settings_controller.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  static const Color _pageBg = Color(0xFFF2F2F7);
  static const Color _cardBg = Colors.white;
  static const Color _borderColor = Color(0xFFE5E5EA);
  static const Color _textPrimary = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        title: const Text(
          AppStrings.profileTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppStrings.fontCairo,
            fontSize: 18.5,
            color: _textPrimary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _cardBg,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: _textPrimary),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.8),
          child: Divider(height: 0.8, color: _borderColor),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar & Live Greeting Preview
              Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor, width: 0.8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF0D9488), Color(0xFF00695C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Obx(() {
                      final name = controller.userName.value.trim();
                      return Column(
                        children: [
                          Text(
                            name.isNotEmpty
                                ? 'مرحبًا بك يا $name '
                                : AppStrings.userGreetingDefault,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppStrings.fontCairo,
                              color: _textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name.isNotEmpty
                                ? 'نسأل الله أن يجعل القرآن ربيع قلبك ونور دربك'
                                : AppStrings.userGreetingSubtitle,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: _textSecondary,
                              fontFamily: AppStrings.fontCairo,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Edit Name Card
              _buildSectionHeader('تعديل البيانات الشخصية'),
              Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor, width: 0.8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اسم المستخدم',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppStrings.fontCairo,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      AppStrings.userNameHelper,
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                        fontFamily: AppStrings.fontCairo,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _borderColor),
                      ),
                      child: TextField(
                        controller: controller.nameTextController,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: AppStrings.fontCairo,
                          color: _textPrimary,
                        ),
                        decoration: const InputDecoration(
                          hintText: AppStrings.userNameHint,
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFB0B0B5),
                            fontFamily: AppStrings.fontCairo,
                          ),
                          prefixIcon: Icon(
                            Icons.badge_outlined,
                            color: Color(0xFF0D9488),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => controller.saveUserName(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D9488),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              AppStrings.saveName,
                              style: TextStyle(
                                fontFamily: AppStrings.fontCairo,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Obx(() {
                          if (controller.userName.value.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: OutlinedButton.icon(
                                onPressed: () => controller.clearUserName(),
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Color(0xFFFF3B30),
                                  size: 18,
                                ),
                                label: const Text(
                                  AppStrings.clearName,
                                  style: TextStyle(
                                    color: Color(0xFFFF3B30),
                                    fontFamily: AppStrings.fontCairo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFFFCDD2)),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Offline privacy note
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              //   decoration: BoxDecoration(
              //     color: _cardBg,
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: _borderColor, width: 0.8),
              //   ),
              //   child: Row(
              //     children: const [
              //       Icon(
              //         Icons.shield_outlined,
              //         color: Color(0xFF0D9488),
              //         size: 20,
              //       ),
              //       SizedBox(width: 10),
              //       Expanded(
              //         child: Text(
              //           'بياناتك محفوظة محلياً على هاتفك تماماً وبأمان، دون أي حاجة للإنترنت أو إنشاء حساب.',
              //           style: TextStyle(
              //             fontSize: 11.5,
              //             color: _textSecondary,
              //             fontFamily: AppStrings.fontCairo,
              //             height: 1.4,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 12, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: _textSecondary,
          fontFamily: AppStrings.fontCairo,
        ),
      ),
    );
  }
}
