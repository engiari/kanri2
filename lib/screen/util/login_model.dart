import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  String mail = '';
  String password = '';

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
    // TODO 端末に保存
  }
}
