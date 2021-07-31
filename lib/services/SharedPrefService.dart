import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static final SharedPrefService _singleton = SharedPrefService._internal();
  SharedPrefService._internal();
  factory SharedPrefService() {
    return _singleton;
  }
  static const String KEY_USER_LOGGEDIN = 'isUserLoggedIn';
  static const String KEY_USER_ID = 'userId';
  late SharedPreferences _prefs;

  intPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setUserLoggedIn(bool loggedIn) async {
    return _prefs.setBool(KEY_USER_LOGGEDIN, loggedIn);
  }

  bool isUserLoggedIn() {
    return _prefs.getBool(KEY_USER_LOGGEDIN) ?? false;
  }

  Future<bool> setCurrentUserId(String userId) async {
    return _prefs.setString(KEY_USER_ID, userId);
  }

  String getCurrentUserId() {
    return _prefs.getString(KEY_USER_ID) ?? "";
  }

  Future<bool> clearUser() async {
    var bool = await _prefs.setString(KEY_USER_ID, "");
    var bool2 = await _prefs.setBool(KEY_USER_LOGGEDIN, false);
    return bool && bool2;
  }
}
