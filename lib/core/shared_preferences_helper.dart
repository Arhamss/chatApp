import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._privateConstructor();

  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._privateConstructor();

  static SharedPreferencesHelper get instance => _instance;

  SharedPreferences? _preferences;

  static Future<void> init() async {
    _instance._preferences = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    if (_preferences != null) {
      await _preferences!.setString(key, value);
    } else {
      throw Exception('SharedPreferences not initialized');
    }
  }

  String? getString(String key) {
    return _preferences?.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    if (_preferences != null) {
      await _preferences!.setBool(key, value);
    } else {
      throw Exception('SharedPreferences not initialized');
    }
  }

  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  Future<void> setStringList(String key, List<String> value) async {
    if (_preferences != null) {
      await _preferences!.setStringList(key, value);
    } else {
      throw Exception('SharedPreferences not initialized');
    }
  }

  List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }
}
