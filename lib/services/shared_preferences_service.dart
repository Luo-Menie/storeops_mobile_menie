import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const tokenKey = 'auth_token';
  static const userAuthenticated = 'user_authenticated';
  static const customerSelected = 'customer_selected';
  static const customerSelectedJson = 'customer_selected_json';
  static const customerCodeSelected = 'customer_code_selected';
  static const storeSelected = 'store_selected';
  static const storeIdSelected = 'store_Id_selected';
  static const storeSelectedJson = 'store_selected_json';
  static const groupSelected = 'group_selected';
  static const groupIdSelected = 'group_id_selected';
  static const rfSelected = 'rf_selected';
  static const rfidSelected = 'rfid_selected';
  static const soldSelected = 'sold_selected';
  static const pushSelected = 'push_selected';
  static const tokenMobile = 'token_mobile';



  static Future<void> saveSharedPreference(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
    
  }

  static Future<void> saveMultipleSharedPreference(List<Map<String,dynamic>> valuesToSave) async {
    final preferences = await SharedPreferences.getInstance();
    for (var item in valuesToSave) {
      final key= item.keys.elementAt(0);
      final value= item.values.elementAt(0);
      if(value is String) await preferences.setString(key, value);
      if(value is bool) await preferences.setBool(key, value);
    }
  }

  static Future<String?> getSharedPreference(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  static Future<bool?> getSharedPreferenceBool(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key);
  }

  static Future<void> clearSharedPreference(String key) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

  static Future<void> clearAllSharedPreference() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }



  //token
  // static Future<void> saveLoginInfo(String token, String user) async {
  //   final preferences = await SharedPreferences.getInstance();
  //   await preferences.setString(_tokenKey, token);
  //   await preferences.setString(_userAuthenticated, user);
  // }

  // static Future<String?> getLoginToken() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   return preferences.getString(_tokenKey);
  // }

  // static Future<void> clearLoginInfo() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   await preferences.remove(_tokenKey);
  //   await preferences.remove(_userAuthenticated);
  // }

  //user



 

}
