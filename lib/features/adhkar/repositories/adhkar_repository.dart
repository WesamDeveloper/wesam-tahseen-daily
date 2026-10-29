import '../../../core/services/storage_service.dart';
import '../data/adhkar_data.dart';
import '../models/zikr_category.dart';
import '../models/zikr_item.dart';

class AdhkarRepository {
  final StorageService _storageService;

  AdhkarRepository({required StorageService storageService})
    : _storageService = storageService;

  List<ZikrItem> getAzkar(ZikrCategoryType type) {
    return AdhkarData.getItemsByCategory(type);
  }

  int getTotalReadCount() {
    return _storageService.getTotalReadCount();
  }

  Future<int> addReadCount(int count) async {
    return await _storageService.addReadCount(count);
  }
}
