import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

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

      },
    );
  }
}
