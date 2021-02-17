import 'package:flutter/material.dart';

class Top extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("食事栄養管理アプリ BBF"),
      ),

      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                    "食事栄養管理アプリ",
                    style: TextStyle(color: Colors.grey, fontSize: 20)
                ),
                margin: EdgeInsets.fromLTRB(30, 50, 0, 0),
              ),
              Container(
                child: Text(
                    "BBF",
                    style: TextStyle(color: Colors.black,
                        fontSize: 100,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)
                ),
              ),
              Container(
                child: Text(
                    "Build your body with food",
                    style: TextStyle(
                        color: Colors.grey, fontSize: 20)
                ),
              ),
              Container(
                child: Image.asset(
                    'images/top_vegetables.jpg'
                ),
                // 内側余白
                padding: EdgeInsets.all(0),
                // 外側余白
                margin: EdgeInsets.all(0),
                width: 400,
              ),

              Container(
                child: RaisedButton(
                  onPressed: () => Navigator.of(context).pushNamed("/login_route"), child: Text('　　　ログイン　　　'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
