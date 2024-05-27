import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._internal();
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._internal();
  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Set a string value
  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  // Get a string value
  String? getString(String key) {
    return _preferences.getString(key);
  }

  // Set a boolean value
  Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  // Get a boolean value
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }
}
