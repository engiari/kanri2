import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';

import 'login_model.dart';

class SignUpModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  String userName = '';
  String userBirth = '';
  String userGender = '';
  String userHeight = '';
  String userWeight = '';
  String userBodyBatPercentage = '';
  String userRegular = '';
  String targetWeight = '';

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future signUp() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }
    if (userName.isEmpty) {
      throw ('お名前を入力してください');
    }
    // todo
    final user = (await _auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    ))
        .user;
    final email = user.email;

    FirebaseFirestore.instance.collection('user').doc(user.uid).set(
      {
        'uid': user.uid,
        'email': email,
        'displayName': user.displayName,
        'userName': userName,
        'userBirth': userBirth,
        'userGender': userGender,
        'userHeight': userHeight,
        'userWeight': userWeight,
        'userBodyBatPercentage': userBodyBatPercentage,
        'userRegular': userRegular,
        'targetWeight': targetWeight,
        'groupList': [],
      },
    ).then((value) => FirebaseFirestore.instance
            .collection("user")
            .where("uid", isEqualTo: user.uid)
            .get()
            .then((value) {
          // TODO 端末に保存
          SharedDataController().setData(LoginModel()
            ..userId = user.uid
            ..userName = userName
            ..userDocument = value.docs.first.id);
        }));
  }
}
