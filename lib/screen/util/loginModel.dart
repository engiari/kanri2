import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/sharedDataController.dart';

class LoginModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  String userId = '';
  String userName = '';
  String userDocument = "";
  String userBirth = "";
  String groupName;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future login() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    // todo
    final result = await _auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );
    final uid = result.user.uid;
    print(result.user.email);

    // TODO 端末に保存
    await SharedDataController().setData(LoginModel()
      ..userId = result.user.uid
      ..userName = result.user.email
    );
  }
}
