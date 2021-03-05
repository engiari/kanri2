import 'package:flutter_app7/screen/util/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String USER_ID_STR =  "user_id";
const String USER_NAME_STR =  "user_name";

class SharedDataController {
  static SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setData(LoginModel data) async {
    await _prefs.setString(USER_ID_STR, data.userId);
    await _prefs.setString(USER_NAME_STR, data.userName);
  }

  LoginModel getData() => LoginModel()
    ..userId = _prefs.getString(USER_ID_STR)
    ..userName = _prefs.getString(USER_NAME_STR) ?? "";
}

