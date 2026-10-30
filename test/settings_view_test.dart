import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dene/core/constants/app_strings.dart';
import 'package:dene/core/notifications/notification_service.dart';
import 'package:dene/core/services/storage_service.dart';
import 'package:dene/features/settings/controllers/notification_controller.dart';
import 'package:dene/features/settings/controllers/settings_controller.dart';
import 'package:dene/features/settings/views/app_guide_view.dart';
import 'package:dene/features/settings/views/developer_view.dart';
import 'package:dene/features/settings/views/notification_settings_view.dart';
import 'package:dene/features/settings/views/settings_view.dart';
import 'package:dene/features/settings/views/user_profile_view.dart';

// Fake NotificationService for testing without native platform channels
class FakeNotificationService extends NotificationService {
  bool permissionGranted = true;
  int? lastScheduledInterval;
  bool wasReminderCanceled = false;
  bool wasTestNotificationSent = false;

  @override
  Future<NotificationService> init() async => this;

  @override
  Future<bool> isPermissionGranted() async => permissionGranted;

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<DateTime?> scheduleInactivityReminder({
    int? customIntervalDays,
    int? preferredHour,
  }) async {
    lastScheduledInterval = customIntervalDays ?? 3;
    wasReminderCanceled = false;
    return DateTime.now().add(Duration(days: lastScheduledInterval!));
  }

  @override
  Future<void> cancelReminder() async {
    wasReminderCanceled = true;
  }

  @override
  Future<void> sendTestNotification() async {
    wasTestNotificationSent = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeNotificationService fakeNotificationService;
  late StorageService storageService;

  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
    storageService = StorageService();
    await storageService.init();
    Get.put<StorageService>(storageService, permanent: true);

    fakeNotificationService = FakeNotificationService();
    Get.put<NotificationService>(fakeNotificationService, permanent: true);

    Get.put<SettingsController>(SettingsController());
    Get.put<NotificationController>(NotificationController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('SettingsView renders clean master menu with all sections', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const GetMaterialApp(
        locale: Locale('ar'),
        home: SettingsView(),
      ),
    );
    await tester.pump();

    // Verify Master AppBar Title
    expect(find.text(AppStrings.settingsTitle), findsOneWidget);

    // Verify Section Master Cards
    expect(find.text(AppStrings.userGreetingDefault), findsOneWidget);
    expect(find.text(AppStrings.quranReminderTitle), findsOneWidget);
    expect(find.text(AppStrings.appGuideTitle), findsOneWidget);
    expect(find.text(AppStrings.developerName), findsOneWidget);

    // 1. Test navigation into Notification Settings
    await tester.tap(find.text(AppStrings.quranReminderTitle));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationSettingsView), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text(AppStrings.intervalDaily), findsOneWidget);
    expect(find.text('${AppStrings.intervalThreeDays} (موصى به)'), findsOneWidget);
    expect(find.text(AppStrings.intervalWeekly), findsOneWidget);
    expect(find.text(AppStrings.intervalMonthly), findsOneWidget);
    expect(find.text(AppStrings.intervalOff), findsOneWidget);
    expect(find.text(AppStrings.testNotificationTitle), findsOneWidget);

    // Pop back to Settings
    Get.back();
    await tester.pumpAndSettle();

    // 2. Test navigation into Developer View
    await tester.tap(find.text(AppStrings.developerName));
    await tester.pumpAndSettle();

    expect(find.byType(DeveloperInfoView), findsOneWidget);
    expect(find.text(AppStrings.developerBio), findsOneWidget);
    expect(find.text(AppStrings.developerPhone), findsOneWidget);
    expect(find.text('مراسلة المطور'), findsOneWidget);
    // Verify GitHub is completely removed as requested
    expect(find.textContaining('github', findRichText: true), findsNothing);
    expect(find.byIcon(Icons.code), findsNothing);
  });

  testWidgets('Entering name in UserProfileView updates greeting dynamically and saves locally', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const GetMaterialApp(
        locale: Locale('ar'),
        home: SettingsView(),
      ),
    );
    await tester.pump();

    // Tap on Profile master card to navigate to UserProfileView
    await tester.tap(find.text(AppStrings.userGreetingDefault));
    await tester.pumpAndSettle();

    expect(find.byType(UserProfileView), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text(AppStrings.saveName), findsOneWidget);

    // Enter name
    await tester.enterText(find.byType(TextField), 'وسام الجنيد');
    await tester.tap(find.text(AppStrings.saveName));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    // Verify dynamic greeting updated
    expect(find.text('مرحبًا بك يا وسام الجنيد 🌸'), findsOneWidget);
    expect(storageService.getUserName(), 'وسام الجنيد');

    // Pop back to SettingsView to verify greeting updated on master page too!
    Get.back();
    await tester.pumpAndSettle();
    expect(find.text('مرحبًا بك يا وسام الجنيد 🌸'), findsOneWidget);

    // Return to UserProfileView to test clear
    await tester.tap(find.text('مرحبًا بك يا وسام الجنيد 🌸'));
    await tester.pumpAndSettle();

    final deleteIcon = find.byIcon(Icons.delete_outline_rounded);
    expect(deleteIcon, findsOneWidget);
    await tester.tap(deleteIcon);
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    expect(find.text(AppStrings.userGreetingDefault), findsOneWidget);
    expect(storageService.getUserName(), isNull);
  });

  testWidgets('Tapping App Guide opens AppGuideView with all 5 guides', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const GetMaterialApp(
        locale: Locale('ar'),
        home: SettingsView(),
      ),
    );
    await tester.pump();

    // Tap on App Guide
    await tester.tap(find.text(AppStrings.appGuideTitle));
    await tester.pumpAndSettle();

    expect(find.byType(AppGuideView), findsOneWidget);
    expect(find.text('أذكار الصباح والمساء والتحصين'), findsOneWidget);
    expect(find.text('المصحف الشريف للقراءة'), findsOneWidget);
    expect(find.text('القرآن الصوتي والاستماع'), findsOneWidget);
    expect(find.text('أدوات التحكم بالتلاوة'), findsOneWidget);
    expect(find.text('تذكيرات القرآن الكريم الذكية'), findsOneWidget);
  });
}
