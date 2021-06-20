import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';

class GroupModel {
  DateTime date ;
  String message ;
  String userId ;
  String groupName;

  GroupModel({this.date,this.message,this.userId, this.groupName});

  toJson() => {
    "date": date.toIso8601String(),
    "message": message,
    "sendUser": userId,
    "groupName": groupName,
  };

}
