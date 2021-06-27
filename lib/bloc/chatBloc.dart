import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app7/model/chatDataModel.dart';

class ChatBloc {
  // FirebaseDatabaseの指定
  DatabaseReference _notesReference;

  final StreamController<ChatDataModel> _sendStream = StreamController<ChatDataModel>();
  final StreamController<ChatDataModel> sendResultStream = StreamController<ChatDataModel>();

  // クラス名（ChatBloc）と関数名（ChatBloc）が同じ場合はクラスが作成された時に最初に実行される
  // ChatBloc() の引数に userName を引っ張ってくる
  ChatBloc(String groupID) {
    _notesReference = FirebaseDatabase.instance.reference().child(groupID);

    // RealTimeDatabaseにデータ追加があった時に通知が .onChildAdded に飛び、.listen で受け取る
    // RealTimeDatabaseからは Eventという型でデータが送られて来る
    _notesReference.onChildAdded.listen((Event event) {
      // event.snapshot.value という変数の中の ["userName"] に入っている値を取って自分の userName と比較
      // RealTimeDatabaseからの通知は誰がデータを入れたかは関係なくデータが飛んでくるため
      // 一致した場合、送信者は自分なので何もしない
        // 不一致の場合、Blocにデータを渡す
        // chatBlocは chatDataModel という型でやり取りを行うのでEvent型をchatDataModelFromSnapShot関数でchatDataModel型に変換（chatDataModelFromSnapShot(event.snapshot)）
        // 変換処理はchatDataModel.dartのchatDataModelクラス内に変換用の関数がある
        sendResultStream.sink.add(chatDataModelFromSnapShot(event.snapshot));
    });
  }

  // send関数にRealtimeDatabaseにデータを送信する処理を書いている
  send(ChatDataModel data) {
    // _notesReference という変数にFirebaseとやり取りするための要素を入れる
    // push()で送信、set(<値>)で送信するデータを入れられる
    // .then((_){}); でデータ送信が成功した後に実行する処理
    _notesReference.push().set(data.toJson()).then((_) {
      // データ送信が成功したらchatBlocにデータを渡す
    });
  }

  getMessege(){
    _notesReference.once().then((values) => (values.value as Map<dynamic, dynamic>).forEach((key, value) {
      sendResultStream.sink.add(chatDataModelFromMap(value));

      print(value);
    }));

  }


  dispose() {
    _sendStream.close();
    sendResultStream.close();
  }
}