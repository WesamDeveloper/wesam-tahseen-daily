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

  // --- User Profile ---
  String? getUserName() {
    final name = _prefs.getString(StorageKeys.userName);
    if (name != null && name.trim().isNotEmpty) {
      return name.trim();
    }
    return null;
  }

  Future<bool> setUserName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return await removeUserName();
    }
    return await _prefs.setString(StorageKeys.userName, trimmed);
  }

  Future<bool> removeUserName() async {
    return await _prefs.remove(StorageKeys.userName);
  }

  // --- Notifications Preferences ---
  bool isNotificationsEnabled({bool defaultValue = true}) {
    return _prefs.getBool(StorageKeys.notificationsEnabled) ?? defaultValue;
  }

  Future<bool> setNotificationsEnabled(bool value) async {
    return await _prefs.setBool(StorageKeys.notificationsEnabled, value);
  }

  int getNotificationIntervalDays({int defaultValue = 3}) {
    return _prefs.getInt(StorageKeys.notificationIntervalDays) ?? defaultValue;
  }

  Future<bool> setNotificationIntervalDays(int days) async {
    return await _prefs.setInt(StorageKeys.notificationIntervalDays, days);
  }

  int getNotificationPreferredHour({int defaultValue = 19}) {
    return _prefs.getInt(StorageKeys.notificationPreferredHour) ?? defaultValue;
  }

  Future<bool> setNotificationPreferredHour(int hour) async {
    return await _prefs.setInt(StorageKeys.notificationPreferredHour, hour);
  }

  int? getLastAppActiveTimestamp() {
    return _prefs.getInt(StorageKeys.lastAppActiveTimestamp);
  }

  Future<bool> setLastAppActiveTimestamp(int timestamp) async {
    return await _prefs.setInt(StorageKeys.lastAppActiveTimestamp, timestamp);
  }

  int? getLastNotificationMessageId() {
    return _prefs.getInt(StorageKeys.lastNotificationMessageId);
  }

  Future<bool> setLastNotificationMessageId(int id) async {
    return await _prefs.setInt(StorageKeys.lastNotificationMessageId, id);
  }

  int? getNextScheduledNotificationTimestamp() {
    return _prefs.getInt(StorageKeys.nextScheduledNotificationTimestamp);
  }

  Future<bool> setNextScheduledNotificationTimestamp(int? timestamp) async {
    if (timestamp == null) {
      return await _prefs.remove(StorageKeys.nextScheduledNotificationTimestamp);
    }
    return await _prefs.setInt(
      StorageKeys.nextScheduledNotificationTimestamp,
      timestamp,
    );
  }

  SharedPreferences get rawPrefs => _prefs;
}
