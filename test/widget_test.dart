import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dene/core/constants/storage_keys.dart';
import 'package:dene/core/services/storage_service.dart';
import 'package:dene/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({StorageKeys.totalRead: 10});
    final storageService = StorageService();
    await storageService.init();
    Get.put<StorageService>(storageService, permanent: true);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('App renders SplashScreen on launch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('صلي على النبي'), findsOneWidget);
  });
}
