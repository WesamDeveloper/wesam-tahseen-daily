import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxString userName = ''.obs;
  late final TextEditingController nameTextController;

  @override
  void onInit() {
    super.onInit();
    final storedName = _storage.getUserName() ?? '';
    userName.value = storedName;
    nameTextController = TextEditingController(text: storedName);
  }

  void saveUserName([String? inputName]) {
    final nameToSave = (inputName ?? nameTextController.text).trim();
    if (nameToSave.isEmpty) {
      clearUserName();
      return;
    }

    _storage.setUserName(nameToSave);
    userName.value = nameToSave;
    nameTextController.text = nameToSave;

    _showSnackbar('تم الحفظ', AppStrings.nameSavedSuccess);
  }

  void clearUserName() {
    _storage.removeUserName();
    userName.value = '';
    nameTextController.clear();

    _showSnackbar('تم المسح', AppStrings.nameClearedSuccess);
  }

  Future<void> launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> launchTelegram() async {
    final uri = Uri.parse(AppStrings.developerTelegramUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      copyToClipboard(AppStrings.developerTelegramUrl, 'رابط قناة التلجرام');
    }
  }

  void copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackbar('تم النسخ', 'تم نسخ $label إلى الحافظة بنجاح 🌿');
  }

  Future<void> shareApp() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: AppStrings.appShareMessage,
          subject: 'تطبيق ${AppStrings.appName}',
        ),
      );
    } catch (_) {
      // Fallback to clipboard if native share fails
      Clipboard.setData(const ClipboardData(text: AppStrings.appShareMessage));
      _showSnackbar('تم نسخ رابط التطبيق', 'تم نسخ رسالة ورابط مشاركة التطبيق إلى الحافظة بنجاح 🌿');
    }
  }

  void _showSnackbar(String title, String message) {
    if (Get.context != null && Get.overlayContext != null) {
      try {
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        );
      } catch (_) {}
    }
  }

  @override
  void onClose() {
    nameTextController.dispose();
    super.onClose();
  }
}
