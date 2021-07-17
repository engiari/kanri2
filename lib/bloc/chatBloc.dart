import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/model/chatDataModel.dart';
import 'package:flutter_app7/model/userData.dart';
import 'package:flutter_app7/screen/util/loadingNotifier.dart';
import 'package:flutter_app7/screen/util/loginModel.dart';
import 'package:flutter_app7/screen/util/sharedDataController.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatBloc {
  // DatabaseReference という型を定義
  late DatabaseReference _notesReference;

  final StreamController<List<ChatDataModel>> _sendStream = StreamController<
      List<ChatDataModel>>();
  final StreamController<
      List<ChatDataModel>> sendResultStream = StreamController<
      List<ChatDataModel>>();
  final StreamController<String?> getUserNameStream = StreamController<String?>();

  // List<ChatDataModel>型の chatModelList に空の配列を定義
  List<ChatDataModel> chatModelList = [];

  // クラス名（ChatBloc）と関数名（ChatBloc）が同じ場合はクラスが作成された時に最初に実行される
  // ChatBloc() の引数に groupID を引っ張ってくる
  ChatBloc(String groupID) {
    // FirebaseDatabaseの指定 groupID を取得
    _notesReference = FirebaseDatabase.instance.reference().child(groupID);

    // RealTimeDatabaseにデータ追加があった時に通知が .onChildAdded に飛び、.listen で受け取る
    // RealTimeDatabaseからは Eventという型でデータが送られて来る
    _notesReference.onChildAdded.listen((Event event) {
      // event.snapshot.value という変数の中の ["userName"] に入っている値を取って自分の userName と比較
      // RealTimeDatabaseからの通知は誰がデータを入れたかは関係なくデータが飛んでくるため
      // サーバに登録された自分のデータを表示させる処理
      // chatBlocは chatDataModel という型でやり取りを行うのでEvent型をchatDataModelFromSnapShot関数でchatDataModel型に変換（chatDataModelFromSnapShot(event.snapshot)）
      // 変換処理はchatDataModel.dartのchatDataModelクラス内に変換用の関数がある
      chatModelList.add(chatDataModelFromSnapShot(event.snapshot));
      sendResultStream.sink.add(chatModelList);

      //チャットのデータ表示
      //print(event.snapshot.value);
    });
  }

  // send関数にRealtimeDatabaseにデータを送信する処理を書いている
  send(ChatDataModel data) {
    // _notesReference という変数にFirebaseとやり取りするための要素を入れる
    // push()で送信、set(<値>)で送信するデータを入れられる
    // .then((_){}); でデータ送信が成功した後に実行する処理
    _notesReference.push().set(data.toJson()).then((_) {});
  }

  // 以前のメッセージを取得（.once で１回だけ取得、as で送られてくる values.value の型が分からないデータを Map<dynamic, dynamic> として扱う）
  getMessege() {
    _notesReference.once().then((values) =>
        (values.value as Map<dynamic, dynamic>).forEach((key, value) {
          //sendResultStream.sink.add(chatDataModelFromMap(value));
          //print("getMessege");
          //print(value);
        }));
  }

  // ユーザー名の取得
  getUserName() async {
  LoginModel data = SharedDataController().getData();

  final userName =
      await FirebaseFirestore.instance.collection("user")
      .doc(data.userDocument)
      .get();

  String? myUserName = userName.data()!["userName"];

  getUserNameStream.sink.add(myUserName);

  print("chatBlocで取得したユーザー名:");
  print(myUserName);

}

  // リソースを解放
  dispose() {
    _sendStream.close();
    sendResultStream.close();
  }
}
