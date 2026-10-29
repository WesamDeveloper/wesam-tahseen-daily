import 'package:get/get.dart';
import '../models/zikr_category.dart';
import '../models/zikr_item.dart';
import '../repositories/adhkar_repository.dart';

class AdhkarController extends GetxController {
  final AdhkarRepository _repository;

  AdhkarController({required AdhkarRepository repository})
    : _repository = repository;

  final Rx<ZikrCategoryType> currentCategoryType = ZikrCategoryType.sabh.obs;
  final RxList<ZikrItem> azkarList = <ZikrItem>[].obs;
  final RxInt currentReadCount = 0.obs;
  final RxInt totalReadCount = 0.obs;
  final RxInt textFont = 20.obs;

  bool get isFinished => azkarList.isEmpty;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ZikrCategoryType) {
      setCategory(args);
    } else if (args is Map && args['type'] is ZikrCategoryType) {
      setCategory(args['type'] as ZikrCategoryType);
    } else {
      setCategory(ZikrCategoryType.sabh);
    }
    loadTotalReadCount();
  }

  void setCategory(ZikrCategoryType type) {
    currentCategoryType.value = type;
    currentReadCount.value = 0;
    azkarList.assignAll(_repository.getAzkar(type));
  }

  void loadTotalReadCount() {
    totalReadCount.value = _repository.getTotalReadCount();
  }

  Future<void> onTapItem(int index) async {
    if (index < 0 || index >= azkarList.length) return;

    final item = azkarList[index];
    if (item.count > 0) {
      item.count -= 1;
      currentReadCount.value += 1;
      azkarList.refresh();
    }

    if (item.count == 0) {
      azkarList.removeAt(index);
      if (azkarList.isEmpty) {
        await _onFinish();
      }
    }
  }

  Future<void> _onFinish() async {
    final updated = await _repository.addReadCount(currentReadCount.value);
    totalReadCount.value = updated;
  }

  void increaseFontSize() {
    if (textFont.value != 40) {
      textFont.value += 2;
    }
  }

  void decreaseFontSize() {
    if (textFont.value > 19) {
      textFont.value -= 2;
    }
  }
}
