import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app7/screen/util/loadingNotifier.dart';
import 'package:flutter_app7/screen/util/loginModel.dart';
import 'package:flutter_app7/screen/util/sharedDataController.dart';

class LoginBloc {
  final StreamController<bool> controller = StreamController<bool>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LoadingNotifier loading;

  LoginBloc(this.loading);

  Future<bool> login(String mail, String password) async {
    if (mail.isEmpty) {
      controller.sink.addError('メールアドレスを入力してください');
      return false;
    }

    if (password.isEmpty) {
      controller.sink.addError('パスワードを入力してください');
      return false;
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

      FirebaseFirestore.instance.collection("user").where("uid", isEqualTo: result.user!.uid).get().then((value) {
        // TODO 端末に保存
        SharedDataController().setData(LoginModel()
          ..userId = result.user!.uid
          ..userName = result.user!.email
          ..userDocument = value.docs.first.id
        );
      });

      //controller.sink.add(true);
      loading.setLoading(false);
      return true;
    } catch (e) {
      // print("llllllllllll");
      loading.setLoading(false);
      //controller.sink.addError(e);
      return false;
    }
  }
}
