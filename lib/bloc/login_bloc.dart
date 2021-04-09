import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app7/screen/util/loading_notifier.dart';
import 'package:flutter_app7/screen/util/login_model.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';

class LoginBloc {
  final StreamController<bool> controller = StreamController<bool>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future login(String mail, String password) async {
    if (mail.isEmpty) {
      controller.sink.addError('メールアドレスを入力してください');
      return;
    }

    if (password.isEmpty) {
      controller.sink.addError('パスワードを入力してください');
      return;
    }

    LoadingNotifier.it<LoadingNotifier>().loadingFlag = false;
    await new Future.delayed(new Duration(seconds: 5));
    // todo
    final result = await _auth
        .signInWithEmailAndPassword(
      email: mail,
      password: password,
    )
        .then((value) {
      controller.sink.add(true);
    }).catchError((dynamic error){
      controller.sink.addError("ログインに失敗しました。");
    }).whenComplete(() => LoadingNotifier.it<LoadingNotifier>().loadingFlag = false);

    // TODO 端末に保存
    await SharedDataController().setData(LoginModel()
      ..userId = result.user.uid
      ..userName = result.user.email);
  }
}
