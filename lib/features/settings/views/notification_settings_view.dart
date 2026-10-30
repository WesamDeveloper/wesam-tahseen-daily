import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/notification_controller.dart';

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  static const Color _pageBg = Color(0xFFF2F2F7);
  static const Color _cardBg = Colors.white;
  static const Color _borderColor = Color(0xFFE5E5EA);
  static const Color _dividerColor = Color(0xFFE5E5EA);
  static const Color _textPrimary = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        title: const Text(
          AppStrings.notificationSettingsTitle,
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
              // 1. Master Toggle Group
              _buildSectionHeader('حالة التذكير'),
              Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor, width: 0.8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9500),
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.notifications_active_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                AppStrings.quranReminderTitle,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppStrings.fontCairo,
                                  color: _textPrimary,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                AppStrings.quranReminderSubtitle,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: _textSecondary,
                                  fontFamily: AppStrings.fontCairo,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => Switch(
                            value: controller.isNotificationsEnabled.value,
                            onChanged: (val) => controller.toggleNotifications(val),
                            activeTrackColor: const Color(0xFF34C759),
                            activeThumbColor: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // Permission Warning
                    Obx(() {
                      if (!controller.hasPermission.value &&
                          controller.isNotificationsEnabled.value) {
                        return Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEA),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFFE082)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFF57C00),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  AppStrings.permissionDeniedMessage,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF5D4037),
                                    fontFamily: AppStrings.fontCairo,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => controller.requestPermission(),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFFF57C00),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontFamily: AppStrings.fontCairo,
                                  ),
                                ),
                                child: const Text(AppStrings.grantPermissionButton),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 2. Frequency Selection Group
              _buildSectionHeader('فترة التكرار عند الانقطاع'),
              Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor, width: 0.8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Obx(() {
                  final current = controller.selectedIntervalDays.value;
                  final enabled = controller.isNotificationsEnabled.value;

                  return Column(
                    children: [
                      _buildIntervalTile(
                        title: AppStrings.intervalDaily,
                        subtitle: 'تذكير يومي لطيف عند عدم فتح التطبيق',
                        isSelected: enabled && current == 1,
                        onTap: () => controller.changeInterval(1),
                      ),
                      const Divider(
                        height: 1,
                        indent: 48,
                        endIndent: 0,
                        color: _dividerColor,
                      ),
                      _buildIntervalTile(
                        title: '${AppStrings.intervalThreeDays} (موصى به)',
                        subtitle: 'تذكير متوازن بعد انقطاع 3 أيام كاملة',
                        isSelected: enabled && current == 3,
                        onTap: () => controller.changeInterval(3),
                      ),
                      const Divider(
                        height: 1,
                        indent: 48,
                        endIndent: 0,
                        color: _dividerColor,
                      ),
                      _buildIntervalTile(
                        title: AppStrings.intervalWeekly,
                        subtitle: 'تذكير أسبوعي لتجديد العهد مع المصحف',
                        isSelected: enabled && current == 7,
                        onTap: () => controller.changeInterval(7),
                      ),
                      const Divider(
                        height: 1,
                        indent: 48,
                        endIndent: 0,
                        color: _dividerColor,
                      ),
                      _buildIntervalTile(
                        title: AppStrings.intervalMonthly,
                        subtitle: 'تذكير شهري عند الغياب الطويل',
                        isSelected: enabled && current == 30,
                        onTap: () => controller.changeInterval(30),
                      ),
                      const Divider(
                        height: 1,
                        indent: 48,
                        endIndent: 0,
                        color: _dividerColor,
                      ),
                      _buildIntervalTile(
                        title: AppStrings.intervalOff,
                        subtitle: 'تعطيل جميع إشعارات التذكير نهائيًا',
                        isSelected: !enabled,
                        onTap: () => controller.changeInterval(0),
                        isDestructive: true,
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 22),

              // 3. Test Notification Action Group
              _buildSectionHeader('اختبار النظام'),
              Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor, width: 0.8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.sendTestNotification(),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF007AFF),
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  AppStrings.testNotificationTitle,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppStrings.fontCairo,
                                    color: _textPrimary,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Text(
                                  'إرسال إشعار فوري لتجربة مظهر التذكير واسمك',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: _textSecondary,
                                    fontFamily: AppStrings.fontCairo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 13,
                            color: Color(0xFFC7C7CC),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Standard Caption Footer
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.nightlight_round,
                      size: 14,
                      color: _textSecondary,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'لا يتم إرسال التذكيرات أبدًا أثناء استخدامك للتطبيق، ولا خلال ساعات الليل المتأخرة، مراعاةً لراحتك وهدوء وقتك.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: _textSecondary,
                          fontFamily: AppStrings.fontCairo,
                          height: 1.4,
                        ),
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

  Widget _buildIntervalTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppStrings.fontCairo,
                        color: isDestructive
                            ? const Color(0xFFFF3B30)
                            : _textPrimary,
                      ),
                    ),
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
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: isDestructive
                      ? const Color(0xFFFF3B30)
                      : const Color(0xFF007AFF),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
