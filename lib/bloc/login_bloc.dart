import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app7/screen/util/loading_notifier.dart';
import 'package:flutter_app7/screen/util/login_model.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';

class LoginBloc {
  final StreamController<bool> controller = StreamController<bool>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LoadingNotifier loading;

  LoginBloc(this.loading);

  Future login(String mail, String password) async {
    if (mail.isEmpty) {
      controller.sink.addError('メールアドレスを入力してください');
      return;
    }

    if (password.isEmpty) {
      controller.sink.addError('パスワードを入力してください');
      return;
    }

    print(mail);
    print(password);
    loading.setLoading(true);
    try {
      // todo
      final result = await _auth
          .signInWithEmailAndPassword(
        email: mail,
        password: password,
      ).catchError((dynamic error) {
        throw "ログインに失敗しました。";
      });
      if (result == null || result.user == null) throw "ログインに失敗しました。";

      // TODO 端末に保存
      await SharedDataController().setData(LoginModel()
        ..userId = result.user.uid
        ..userName = result.user.email);

      controller.sink.add(true);
      loading.setLoading(false);
    } catch (e) {
      print("llllllllllll");
      controller.sink.addError(e);
    }
  }
}
