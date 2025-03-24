import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> writeBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  static bool readBool(String key, {bool defaultValue = false}) {
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> clearAll() async {
    await prefs.clear();
  }

  static Future<void> writeString(String key, String value) async {
  await prefs.setString(key, value);
}

static String? readString(String key) {
  return prefs.getString(key);
}

}
