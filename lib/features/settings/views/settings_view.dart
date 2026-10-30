import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/notification_controller.dart';
import '../controllers/settings_controller.dart';
import 'app_guide_view.dart';
import 'developer_view.dart';
import 'notification_settings_view.dart';
import 'user_profile_view.dart';

/// Official standard Settings View following the system inset-grouped design
/// (Apple / Material 3 standard settings pattern).
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  // Official System Settings Palette
  static const Color _pageBg = Color(0xFFF2F2F7);
  static const Color _cardBg = Colors.white;
  static const Color _borderColor = Color(0xFFE5E5EA);
  static const Color _dividerColor = Color(0xFFE5E5EA);
  static const Color _textPrimary = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF8E8E93);
  static const Color _chevronColor = Color(0xFFC7C7CC);

  @override
  Widget build(BuildContext context) {
    final settingsCtrl = Get.put(SettingsController());
    final notifCtrl = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        title: const Text(
          AppStrings.settingsTitle,
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
              // 1. Profile / Account Section
              _buildProfileTile(context, settingsCtrl),
              const SizedBox(height: 22),

              // 2. Preferences & Alerts Group
              _buildSectionHeader('التفضيلات والتنبيهات'),
              _buildGroupContainer(
                children: [
                  _buildSettingsTile(
                    icon: Icons.notifications_active_rounded,
                    iconBg: const Color(0xFFFF9500),
                    title: AppStrings.quranReminderTitle,
                    trailingWidget: Obx(() {
                      final enabled = notifCtrl.isNotificationsEnabled.value;
                      final interval = notifCtrl.selectedIntervalDays.value;
                      final label = enabled
                          ? 'مفعل (${notifCtrl.getIntervalLabel(interval)})'
                          : 'متوقف';
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 13,
                              color: enabled
                                  ? const Color(0xFF34C759)
                                  : _textSecondary,
                              fontFamily: AppStrings.fontCairo,
                              fontWeight: enabled
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 13,
                            color: _chevronColor,
                          ),
                        ],
                      );
                    }),
                    onTap: () {
                      Get.to(
                        () => const NotificationSettingsView(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // 3. Help & Support Group
              _buildSectionHeader('المساعدة والدعم'),
              _buildGroupContainer(
                children: [
                  _buildSettingsTile(
                    icon: Icons.menu_book_rounded,
                    iconBg: const Color(0xFF007AFF),
                    title: AppStrings.appGuideTitle,
                    subtitle: 'شرح استخدام الأذكار، المصحف، والتلاوات',
                    trailingWidget: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 13,
                      color: _chevronColor,
                    ),
                    onTap: () {
                      Get.to(
                        () => const AppGuideView(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  const Divider(
                    height: 1,
                    thickness: 0.7,
                    indent: 58,
                    endIndent: 0,
                    color: _dividerColor,
                  ),
                  _buildSettingsTile(
                    icon: Icons.share_rounded,
                    iconBg: const Color(0xFF34C759),
                    title: 'مشاركة التطبيق',
                    subtitle: 'شارك التطبيق للأجر ونشر الخير',
                    trailingWidget: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 13,
                      color: _chevronColor,
                    ),
                    onTap: (){},
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // 4. About App Group
              _buildSectionHeader('حول التطبيق'),
              _buildGroupContainer(
                children: [
                  _buildSettingsTile(
                    icon: Icons.person_rounded,
                    iconBg: const Color(0xFF5856D6),
                    title: "عن المطور",
                    subtitle: '• تواصل مباشر',
                    trailingWidget: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 13,
                      color: _chevronColor,
                    ),
                    onTap: () {
                      Get.to(
                        () => const DeveloperInfoView(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  const Divider(
                    height: 1,
                    thickness: 0.7,
                    indent: 58,
                    endIndent: 0,
                    color: _dividerColor,
                  ),
                  _buildSettingsTile(
                    icon: Icons.info_outline_rounded,
                    iconBg: const Color(0xFF8E8E93),
                    title: 'إصدار التطبيق',
                    trailingWidget: const Text(
                      '1.0.0 (رسمي)',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: _textSecondary,
                        fontFamily: AppStrings.fontCairo,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 0.7,
                    indent: 58,
                    endIndent: 0,
                    color: _dividerColor,
                  ),
                  _buildSettingsTile(
                    icon: Icons.verified_outlined,
                    iconBg: const Color(0xFF0D9488),
                    title: 'التطبيق',
                    trailingWidget: const Text(
                      'مجاني وبدون إعلانات',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF0D9488),
                        fontWeight: FontWeight.bold,
                        fontFamily: AppStrings.fontCairo,
                      ),
                    ),
                  ),
                ],
              ),

              // Standard Settings Footer
              const SizedBox(height: 28),
              Center(
                child: Column(
                  children: const [
                    Text(
                      'تطبيق وسام للتحصين اليومي 🌿',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: _textSecondary,
                        fontFamily: AppStrings.fontCairo,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'اللهم اجعل هذا العمل خالصًا لوجهك الكريم',
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

  // -------------------------------------------------------------
  // Section Header Label
  // -------------------------------------------------------------
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

  // -------------------------------------------------------------
  // Inset Grouped Container
  // -------------------------------------------------------------
  Widget _buildGroupContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 0.8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  // -------------------------------------------------------------
  // Profile Master Tile
  // -------------------------------------------------------------
  Widget _buildProfileTile(
    BuildContext context,
    SettingsController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 0.8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(
              () => const UserProfileView(),
              transition: Transition.rightToLeft,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Profile Avatar Circle
                Container(
                  width: 50,
                  height: 50,
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
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Obx(() {
                    final name = controller.userName.value.trim();
                    final titleText = name.isNotEmpty
                        ? 'مرحبًا بك يا $name '
                        : AppStrings.userGreetingDefault;
                    final subtitleText = name.isNotEmpty
                        ? 'الملف الشخصي • اضغط للتعديل'
                        : 'اضغط لتخصيص اسمك ورسائل التذكير';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppStrings.fontCairo,
                            color: _textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitleText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _textSecondary,
                            fontFamily: AppStrings.fontCairo,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14,
                  color: _chevronColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Standard Settings List Tile with Squircle Icon
  // -------------------------------------------------------------
  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconBg,
    required String title,
    String? subtitle,
    Widget? trailingWidget,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
              // Standard Rounded Square (Squircle) Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(7.5),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              // Title & Optional Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppStrings.fontCairo,
                        color: _textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: _textSecondary,
                          fontFamily: AppStrings.fontCairo,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailingWidget != null) trailingWidget,
            ],
          ),
        ),
      ),
    );
  }
}
