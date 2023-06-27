import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._();
  static SharedPreferenceHelper sharedHelper = SharedPreferenceHelper._();
  SharedPreferences? sharedPreferences;
  initSharedPreferences() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }
  Future<bool> saveStringToSharedPreferences(String key, String value) async{
    return  sharedPreferences!.setString(key, value);

  }
  Future<String?> getStringFromSharedPreferences(String key) async{
    return sharedPreferences!.getString(key);

  }

}