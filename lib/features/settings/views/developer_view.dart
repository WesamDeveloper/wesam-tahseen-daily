import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/settings_controller.dart';

class DeveloperInfoView extends StatelessWidget {
  const DeveloperInfoView({super.key});

  static const Color _pageBg = Color(0xFFF2F2F7);
  static const Color _cardBg = Colors.white;
  static const Color _borderColor = Color(0xFFE5E5EA);
  static const Color _dividerColor = Color(0xFFE5E5EA);
  static const Color _textPrimary = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        title: const Text(
          AppStrings.aboutDeveloperTitle,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Developer Profile Header
              Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor, width: 0.8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0D9488), width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 44,
                        backgroundImage: AssetImage(AppAssets.profile),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      AppStrings.developerName,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppStrings.fontCairo,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      AppStrings.developerRole,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0D9488),
                        fontWeight: FontWeight.w600,
                        fontFamily: AppStrings.fontCairo,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        AppStrings.developerBio,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Color(0xFF3A3A3C),
                          fontFamily: AppStrings.fontCairo,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Contact Group
              _buildSectionHeader('معلومات التواصل المباشر'),
              Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor, width: 0.8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // Phone Tile
                    _buildContactTile(
                      icon: Icons.phone_rounded,
                      iconBg: const Color(0xFF34C759),
                      title: 'رقم الهاتف',
                      value: AppStrings.developerPhone,
                      actionLabel: 'اتصال / نسخ',
                      onTap: () => controller.launchPhone(AppStrings.developerPhone),
                      onLongPress: () => controller.copyToClipboard(
                        AppStrings.developerPhone,
                        'رقم الهاتف',
                      ),
                    ),
                    const Divider(
                      height: 1,
                      indent: 58,
                      endIndent: 0,
                      color: _dividerColor,
                    ),
                    // Email Tile
                    _buildContactTile(
                      icon: Icons.mail_outline_rounded,
                      iconBg: const Color(0xFF007AFF),
                      title: 'البريد الإلكتروني',
                      value: AppStrings.developerEmail,
                      actionLabel: 'مراسلة المطور',
                      onTap: () => controller.launchEmail(AppStrings.developerEmail),
                      onLongPress: () => controller.copyToClipboard(
                        AppStrings.developerEmail,
                        'البريد الإلكتروني',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Official Footer
              Center(
                child: Column(
                  children: const [
                    Text(
                      'تطبيق وسام للتحصين اليومي • إصدار 1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _textSecondary,
                        fontFamily: AppStrings.fontCairo,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'نسألكم الدعاء بظهر الغيب 🌿',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFFA5A5AA),
                        fontFamily: AppStrings.fontCairo,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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

  Widget _buildContactTile({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String value,
    required String actionLabel,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(7.5),
                ),
                child: Center(
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                        fontFamily: AppStrings.fontCairo,
                      ),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppStrings.fontCairo,
                        color: _textPrimary,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF007AFF),
                    fontFamily: AppStrings.fontCairo,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
