import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/login_model.dart';
import 'package:flutter_app7/screen/util/login_route.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';

import 'group/group_route.dart';
import 'group/user_seach.dart';

class Setting extends StatelessWidget {
  LoginModel get sharedData => SharedDataController().getData();
  Query query = FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        actions: <Widget>[
          RaisedButton.icon(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: const Text('ログアウト'),
            onPressed: () async {
              // 内部で保持しているログイン情報を初期化
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
            // ボタンの背景色
            color: Colors.blue,
            textColor: Colors.white,
          ),
        ],
      ),
      body: Container(
        // ユーザー情報を表示
        child: Text(
          FirebaseAuth.instance.currentUser.email,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
