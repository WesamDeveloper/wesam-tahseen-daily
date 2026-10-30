import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/initial_binding.dart';
import 'core/constants/app_strings.dart';
import 'core/notifications/notification_service.dart';
import 'core/routes/app_pages.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<StorageService>(
    () async => await StorageService().init(),
    permanent: true,
  );
  await Get.putAsync<NotificationService>(
    () async => await NotificationService().init(),
    permanent: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      locale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
    );
  }
}
