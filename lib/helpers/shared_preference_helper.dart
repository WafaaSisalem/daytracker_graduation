import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._();
  static SharedPreferenceHelper sharedHelper = SharedPreferenceHelper._();
  SharedPreferences? sharedPreferences;
  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> saveStringToSharedPreferences(String key, String value) async {
    return sharedPreferences!.setString(key, value);
  }

  Future<bool> saveIntToSharedPreferences(String key, int value) async {
    return sharedPreferences!.setInt(key, value);
  }

  Future<int?> getIntFromSharedPreferences(String key) async {
    return sharedPreferences!.getInt(key);
  }

  Future<String?> getStringFromSharedPreferences(String key) async {
    return sharedPreferences!.getString(key);
  }

  setTheme(choice) => sharedPreferences!.setInt('Theme', choice);
  getTheme() => sharedPreferences!.getInt('Theme');
  setView(choice) => sharedPreferences!.setInt('View', choice);
  getView() => sharedPreferences!.getInt('View');
}
