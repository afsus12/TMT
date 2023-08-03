import 'package:shared_preferences/shared_preferences.dart';

class UserPrefrences {
  static SharedPreferences? _preferences;
  static const _userEmail = "email";
  static const _currentOrg = "orgGuid";
  static const _userGuid = "userGuid";
  static const _userValid = "userValid";
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserEmail(String email) async =>
      await _preferences!.setString(_userEmail, email);
  static Future deleteAll() async => await _preferences!.clear();

  static String? getUserEmail() => _preferences?.getString(_userEmail);
  static Future setUserGuid(String guid) async =>
      await _preferences!.setString(_userGuid, guid);

  static String? getUserGuid() => _preferences?.getString(_userGuid);

  static Future setCureentOrg(String guid) async =>
      await _preferences!.setString(_currentOrg, guid);

  static String? getCureentOrg() => _preferences?.getString(_currentOrg);

  static Future setCureentIsValid(bool valid) async =>
      await _preferences!.setBool(_userValid, valid);

  static bool? getCureentIsValid() => _preferences?.getBool(_userValid);
}
