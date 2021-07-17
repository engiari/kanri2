import 'package:flutter_app7/screen/util/loginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String USER_ID_STR =  "user_id";
const String USER_NAME_STR =  "user_name";
const String USER_DOCUMENT_STR =  "user_document";
const String USER_BIRTH_STR =  "user_birth";
const String USER_GROUP_STR =  "group_name";

class SharedDataController {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setData(LoginModel data) async {
    await _prefs.setString(USER_ID_STR, data.userId!);
    await _prefs.setString(USER_NAME_STR, data.userName!);
    await _prefs.setString(USER_DOCUMENT_STR, data.userDocument);
    await _prefs.setString(USER_BIRTH_STR, data.userBirth);
    await _prefs.setString(USER_GROUP_STR, data.groupName!);

  }

  LoginModel getData() => LoginModel()
    ..userId = _prefs.getString(USER_ID_STR)
    ..userName = _prefs.getString(USER_NAME_STR) ?? ""
    ..userDocument = _prefs.getString(USER_DOCUMENT_STR) ?? ""
    ..userBirth = _prefs.getString(USER_BIRTH_STR) ?? ""
    ..groupName = _prefs.getString(USER_GROUP_STR);

}

