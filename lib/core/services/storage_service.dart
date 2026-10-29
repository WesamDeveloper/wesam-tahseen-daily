import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class StorageService extends GetxService {
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  int getTotalReadCount() {
    return _prefs.getInt(StorageKeys.totalRead) ?? 0;
  }

  Future<bool> setTotalReadCount(int value) async {
    return await _prefs.setInt(StorageKeys.totalRead, value);
  }

  Future<int> addReadCount(int added) async {
    final currentTotal = getTotalReadCount();
    final newTotal = currentTotal + added;
    await setTotalReadCount(newTotal);
    return newTotal;
  }

  SharedPreferences get rawPrefs => _prefs;
}
