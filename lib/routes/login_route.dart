import 'package:flutter/material.dart';
import '../tile.dart';

class Talk extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ログイン"),
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