import 'package:firebase_database/firebase_database.dart';

// Event型をfromSnapshot関数でchatDataModel型に変換
ChatDataModel chatDataModelFromSnapShot(DataSnapshot data) => ChatDataModel.fromSnapshot(data);
ChatDataModel chatDataModelFromMap(Map<dynamic, dynamic> data) => ChatDataModel.fromMap(data);

class ChatDataModel {
  String? userUid;
  String? userName;
  DateTime? date;
  String? message;

  ChatDataModel({
    this.userUid,
    this.userName,
    this.date,
    this.message,
  });

  // RealtimeDatabaseはJSONというデータ形式なのでChatDataModelクラスのデータをJSON化（Map形に変換）
  Map<String, dynamic> toJson() => <String, dynamic>{
    "userUid": userUid,
    "userName": userName,
    "dateTime": date!.toLocal().toIso8601String(),
    "message": message,
  };

  factory ChatDataModel.fromSnapshot(DataSnapshot  snapshot) => ChatDataModel(
    userUid: snapshot.value["userUid"],
    userName: snapshot.value["userName"],
    date: snapshot.value["date"],
    message: snapshot.value["message"],
  );

  factory ChatDataModel.fromMap(Map<dynamic, dynamic> data) => ChatDataModel(
    userUid: data["userUid"],
    userName: data["userName"],
    date: data["date"],
    message: data["message"],
  );

}


