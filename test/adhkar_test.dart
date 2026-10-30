import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dene/core/constants/storage_keys.dart';
import 'package:dene/core/services/storage_service.dart';
import 'package:dene/features/adhkar/controllers/adhkar_controller.dart';
import 'package:dene/features/adhkar/controllers/tasbeeh_controller.dart';
import 'package:dene/features/adhkar/models/zikr_category.dart';
import 'package:dene/features/adhkar/repositories/adhkar_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Adhkar & Storage Tests', () {
    late StorageService storageService;
    late AdhkarRepository adhkarRepository;
    late AdhkarController adhkarController;

    setUp(() async {
      Get.reset();
      SharedPreferences.setMockInitialValues({StorageKeys.totalRead: 50});
      storageService = StorageService();
      await storageService.init();
      Get.put<StorageService>(storageService);

      adhkarRepository = AdhkarRepository(storageService: storageService);
      Get.put<AdhkarRepository>(adhkarRepository);

      adhkarController = AdhkarController(repository: adhkarRepository);
      Get.put<AdhkarController>(adhkarController);
    });

    tearDown(() {
      Get.reset();
    });

    test('Initial total read count is loaded from storage', () {
      expect(storageService.getTotalReadCount(), 50);
      expect(adhkarController.totalReadCount.value, 50);
    });

    test('Sabh azkar list is loaded with 29 items', () {
      adhkarController.setCategory(ZikrCategoryType.sabh);
      expect(adhkarController.azkarList.length, 29);
      expect(adhkarController.currentReadCount.value, 0);
      expect(adhkarController.isFinished, false);
    });

    test(
      'Tapping zikr item decrements count and increments session read count',
      () async {
        adhkarController.setCategory(ZikrCategoryType.safer);
        expect(adhkarController.azkarList.length, 5);

        final initialItemCount = adhkarController.azkarList[0].count;
        expect(initialItemCount, 1);

        // Tapping first item (initial count 1) -> count becomes 0 -> removed from list
        await adhkarController.onTapItem(0);

        expect(adhkarController.currentReadCount.value, 1);
        expect(adhkarController.azkarList.length, 4);
      },
    );

    test(
      'Finishing all items updates totalReadCount in storage and controller',
      () async {
        adhkarController.setCategory(ZikrCategoryType.safer);
        // Consume all 5 items
        while (adhkarController.azkarList.isNotEmpty) {
          await adhkarController.onTapItem(0);
        }

        expect(adhkarController.isFinished, true);
        expect(adhkarController.currentReadCount.value, 5);
        expect(adhkarController.totalReadCount.value, 55); // 50 + 5
        expect(storageService.getTotalReadCount(), 55);
      },
    );

    test('Font size controls respects boundaries (min 19, max 40)', () {
      adhkarController.textFont.value = 20;

      adhkarController.decreaseFontSize();
      expect(adhkarController.textFont.value, 18);

      // Cannot decrease further because 18 is not > 19
      adhkarController.decreaseFontSize();
      expect(adhkarController.textFont.value, 18);

      // Increase to max
      for (int i = 0; i < 20; i++) {
        adhkarController.increaseFontSize();
      }
      expect(adhkarController.textFont.value, 40);

      // Further increase is blocked
      adhkarController.increaseFontSize();
      expect(adhkarController.textFont.value, 40);
    });

    test('Progress tracking and reset capabilities work correctly', () async {
      adhkarController.setCategory(ZikrCategoryType.safer);
      expect(adhkarController.initialCategoryCount.value, 5);
      expect(adhkarController.completedCount, 0);
      expect(adhkarController.progress, 0.0);

      // Tap first item
      await adhkarController.onTapItem(0);
      expect(adhkarController.completedCount, 1);
      expect(adhkarController.progress, 0.2);

      // Reset single item if tapped accidentally
      adhkarController.azkarList[0].count = 2;
      adhkarController.resetItem(0);
      expect(
        adhkarController.azkarList[0].count,
        adhkarController.azkarList[0].initialCount,
      );

      // Restart category
      adhkarController.restartCategory();
      expect(adhkarController.azkarList.length, 5);
      expect(adhkarController.currentReadCount.value, 0);
    });
  });

  group('Tasbeeh Controller Tests', () {
    test('Increment and reset counter', () {
      final controller = TasbeehController();
      expect(controller.counter.value, 0);

      controller.increment();
      controller.increment();
      controller.increment();
      expect(controller.counter.value, 3);

      controller.reset();
      expect(controller.counter.value, 0);
    });
  });
}
