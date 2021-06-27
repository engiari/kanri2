import 'package:firebase_database/firebase_database.dart';

// Event型をfromSnapshot関数でchatDataModel型に変換
ChatDataModel chatDataModelFromSnapShot(DataSnapshot data) => ChatDataModel.fromSnapshot(data);

class ChatDataModel {
  String userName;
  DateTime date;
  String message;

  ChatDataModel({
    this.userName,
    this.date,
    this.message,
  });

  // RealtimeDatabaseはJSONというデータ形式なのでChatDataModelクラスのデータをJSON化（Map形に変換）
  Map<String, dynamic> toJson() => <String, dynamic>{
    "userName": userName,
    "dateTime": date.toLocal().toIso8601String(),
    "message": message,
  };

  factory ChatDataModel.fromSnapshot(DataSnapshot  snapshot) => ChatDataModel(
    userName: snapshot.value["userName"],
    date: snapshot.value["date"],
    message: snapshot.value["message"],
  );
}


