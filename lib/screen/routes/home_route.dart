import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("食事栄養管理アプリ BBF"),
      ),

      body: ListView(
        // padding: const EdgeInsets.all(8),
        children: <Widget>[
          Tile(
            icon: Icons.person,
            username: "名前",
            message: "メールアドレス",
          ),
        ],
      ),
    );
  }
}