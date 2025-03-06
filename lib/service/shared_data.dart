import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  static SharedPreferences? _preferences;

  /// Initialize SharedPreferences (Call this in `main.dart` before using)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Save a string value
  static Future<void> setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  /// Get a string value
  static String? getString(String key) {
    return _preferences?.getString(key);
  }

  /// Save an integer value
  static Future<void> setInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  /// Get an integer value
  static int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  /// Save a boolean value
  static Future<void> setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  /// Get a boolean value
  static bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  /// Remove a specific key
  static Future<void> removeKey(String key) async {
    await _preferences?.remove(key);
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    await _preferences?.clear();
  }
}