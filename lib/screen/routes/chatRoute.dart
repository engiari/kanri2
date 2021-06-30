import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/bloc/chatBloc.dart';
import 'package:flutter_app7/model/chatDataModel.dart';
import 'package:flutter_app7/model/groupData.dart';
import 'package:flutter_app7/model/userData.dart';
import 'package:flutter_app7/screen/util/loadingNotifier.dart';
import 'package:flutter_app7/screen/util/loginModel.dart';
import 'package:flutter_app7/screen/util/sharedDataController.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_fonts/google_fonts.dart';

class Chat extends StatefulWidget {
  String chatGroupPath;

  String title;

  String userName;

  Chat(this.chatGroupPath);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // FirebaseAuthenticationからuidを取得して userUid に入れる
  final String userUid = FirebaseAuth.instance.currentUser.uid;



  // ユーザー名の取得
  LoginModel data = SharedDataController().getData();

  final userName =
      FirebaseFirestore.instance.collection("user")
      .doc(data.userDocument)
      .get();



  // ChatBloc という場所を用意して initState の中身を入れる
  ChatBloc bloc;

  // chatデータを扱う配列
  List<ChatDataModel> message = [];

  // 送信するメッセージのテキスト保持
  String sendMessage;

  // テキストエリアのコントロール
  final _controller = TextEditingController();

  //  initState() という関数内でBlocのデータを受け取る
  void initState() {
    super.initState();
    bloc = ChatBloc(widget.chatGroupPath);
    // .listen((_){}); を使うと処理部分でBlocのデータを受け取れる
    // ※受信したデータも送信時と同じ流れでチャット欄に表示
    // WidgetsBinding.instance.addPostFrameCallback((_){}); でレイアウトが表示された後に実行する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //bloc.getMessege();
    });
    print("chatGroupPath");
    print(widget.chatGroupPath);
  }

  // 送信するデータ
  void _sendMessage() {
    if (sendMessage != null) {
      // テキストデータが入っていれば以下の処理
      // Databaseに登録するデータ内容を ChatDataModel クラスで定義
      ChatDataModel sendData = ChatDataModel()
      // ユーザー名、メッセージ、送信時間をbloc側に渡す
        ..userUid = userUid
        ..userName = userName
        ..message = sendMessage
        ..date = DateTime.now();
      bloc.send(sendData);
      // TextFieldの入力文字を初期化
      _controller.clear();
      // 送信するメッセージを保持していた sendMessage に null を入れる（送信した後のため）
      sendMessage = null;
   }
  }

  @override
  Widget build(BuildContext context) {


    return Provider<ChatBloc>(

      // (_)パラメータを使わないことの明示
      create: (_) => bloc,
      dispose: (_, bloc) => bloc.dispose(),
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Expanded(
                  // StreamBuilder：Blocから受け取ったデータをレイアウトで表示させる時の要素
                  // StreamBuilder<Blocから送られてくるデータの形（この場合：List<ChatDataModel>）>
                  child: StreamBuilder<List<ChatDataModel>>(
                      stream: bloc.sendResultStream.stream,
                      builder: (context, snapshot) {
                        // snapshot にデータがあった場合 ListView の中身を返す
                        if (snapshot.hasData) {
                          return ListView(
                            // true で上から降順表示、スクロールは最古のデータ（最下部）
                            reverse: true,
                            //shrinkWrap: true,

                            padding: const EdgeInsets.all(16.0),

                            // message変数の中のデータをリスト表示（ListView Widget）
                            // .reversed で snapshot.data の map を降順にソート
                            children: snapshot.data.reversed
                                .map(
                                  (e) => Row(
                                children: [
                                  // Expanded の flex: で比率を設定して配置するのがベスト
                                  // e.userName と userName が一致する場合の表示（自分）
                                  e.userUid == userUid
                                      ? Expanded(
                                      flex: 1, child: Container())
                                      : Container(),
                                  Expanded(
                                    flex: 9,
                                    child: Container(
                                      // 内側余白
                                      padding: EdgeInsets.only(
                                          top: 8.0,
                                          right: 8.0,
                                          bottom: 8.0),
                                      // 外側余白
                                      margin: EdgeInsets.all(2),

                                      // chatDataModelのデータ e.userName が自身の userName と一致しているか判定して表示色変更
                                      color: e.userUid == userUid
                                          ? Colors.grey // 一致
                                          : Colors.green.shade300,
                                      // それ以外
                                      child: ListTile(
                                        title: Text(
                                          e.message,
                                          style: TextStyle(
                                            color: e.userUid == userUid
                                                ? Colors.white // 一致
                                                : Colors.black, // それ以外
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // e.userName と userName が不一致の場合の表示（自分以外）
                                  e.userUid != userUid
                                      ? Expanded(
                                      flex: 1, child: Container())
                                      : Container(),
                                ],
                              ),
                            )
                                .toList(),
                          );
                        }
                        //print("");
                        return Container();
                      }),
                ),
              ),

              // メッセージ入力欄
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        //border: OutlineInputBorder(),
                        //hintText: 'メッセージを入力',
                        labelText: 'メッセージを入力',
                      ),
                      // コントローラの指定
                      controller: _controller,
                      // 活性、非活性の切り替え
                      enabled: true,
                      // 入力可能な文字数
                      maxLength: 140,
                      // 入力可能な文字数の制限を超える場合の挙動制御
                      // false: 最大文字数を超えても入力可能（超えると赤文字に）
                      maxLengthEnforced: false,
                      style: TextStyle(color: Colors.black),
                      // true でパスワード入力のように入力している値をマスク
                      obscureText: false,
                      // 入力できる行数の最大行数を設定
                      maxLines: 1,
                      // テキストが入力された時の処理
                      onChanged: (String text) {
                        // テキストが入力された時に sendMessage に送信するデータを入れる
                        sendMessage = text;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      // 入力されたデータを送信
                      _sendMessage();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
