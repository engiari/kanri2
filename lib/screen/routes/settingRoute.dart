import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/loginModel.dart';
import 'package:flutter_app7/screen/util/loginRoute.dart';
import 'package:flutter_app7/screen/util/sharedDataController.dart';
import 'package:package_info/package_info.dart';
import 'group/groupRoute.dart';

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
      body: Column(
        children: [
          Container(
            // ユーザー情報を表示
            child: Text(
              FirebaseAuth.instance.currentUser!.email!,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          TextButton(
            child: Text('ライセンスページの表示'),
            onPressed: () => showLicensePage(
              context: context,
              applicationName: 'BBF',
              applicationVersion: '0.0.1',
            ),
          ),
        ],
      ),
    );
  }
}
