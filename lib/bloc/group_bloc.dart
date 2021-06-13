import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/model/user_data.dart';
import 'package:flutter_app7/screen/util/loading_notifier.dart';
import 'package:flutter_app7/screen/util/login_model.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class GroupBloc {
  final StreamController<UserData> controller = StreamController<UserData>();
  final StreamController<List<dynamic>> groupListController =
  StreamController<List<dynamic>>();
  final LoadingNotifier loading;

  GroupBloc(this.loading);

  searchUser(String searchEmail) {
    CollectionReference query = FirebaseFirestore.instance.collection('user');
    loading.setLoading(true);

    query
        .where("email",
        isEqualTo: searchEmail,
        isNotEqualTo: FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      UserData userData = UserData(
          uid: value.docs.first.data()['uid'],
          displayName: value.docs.first.data()['displayName'],
          email: value.docs.first.data()['email'],
          groupName: value.docs.first.data()['groupName'],
          documentId: value.docs.first.id);

      controller.sink.add(userData);
    }).whenComplete(() => loading.setLoading(false));
  }

  sendGroup({UserData userData}) async {
    // TODO submit
    LoginModel data = SharedDataController().getData();
    final CollectionReference query =
    FirebaseFirestore.instance.collection('group');

    loading.setLoading(true);
    final myData = await FirebaseFirestore.instance
        .collection("user")
        .doc(data.userDocument)
        .get();
    final targetData = await FirebaseFirestore.instance
        .collection("user")
        .doc(userData.documentId)
        .get();

    final List<dynamic> eachGroupList = [];
    (myData.data()["groupList"] as List<dynamic>).forEach((e) {
      eachGroupList.add((targetData.data()["groupList"] as List<dynamic>)
          .firstWhere((element) => e == element));
    });
    bool duplicate = false;
    await Future.forEach(eachGroupList, (element) async {
      final groupData = await (element as DocumentReference).get();
      if ((groupData.get("uidList")).length <= 2) {
        duplicate = true;
      }
    });
    if (duplicate) {
      Fluttertoast.showToast(
          msg: "グループが既に存在します",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0)
          .whenComplete(() => loading.setLoading(false));
    } else {
      query
          .add({
        'uidList': [FirebaseAuth.instance.currentUser.uid, userData.uid],
        'group_name': userData.groupName,
      })

          .then((value) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(userData.documentId)
            .set({
          'groupList': FieldValue.arrayUnion([query.doc(value.id)]),
        }, SetOptions(merge: true));

        FirebaseFirestore.instance
            .collection('user')
            .doc(data.userDocument)
            .set({
          'groupList': FieldValue.arrayUnion([query.doc(value.id)]),
        }, SetOptions(merge: true));
      })
          .then((value) => Fluttertoast.showToast(
          msg: "追加しました",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0))
          .whenComplete(() => loading.setLoading(false))
          .onError((error, stackTrace) => Fluttertoast.showToast(
          msg: "追加できませんでした",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0))
          .whenComplete(() => loading.setLoading(false));
    }
    loading.setLoading(false);
  }

  /*
  searchGroup() {
    LoginModel data = SharedDataController().getData();
    DocumentReference query =
    FirebaseFirestore.instance.collection('user').doc(data.userDocument);
    query.get().then((value) {
      groupListController.sink.add(value.data()["groupName"]);

      print("data.userDocument");
      print(data.userDocument);

    });
  }

   */

  // 登録グループ検索
  searchGroup() async {
    LoginModel data = SharedDataController().getData();
    // FirebaseFirestore の user コレクションを参照
    DocumentReference query =
    FirebaseFirestore.instance.collection('user').doc(data.userDocument);

    print("data.userDocument");
    print(data.userDocument);

    loading.setLoading(true);

    // user から userDocument に登録された uid 取得
    final myData = await FirebaseFirestore.instance
        .collection("user")
        .doc(data.userDocument)
        .get();

    // 一致した uid の groupList を検索
    final List<dynamic> eachGroupList = [];
    (myData.data()["groupList"] as List<dynamic>).forEach((e) {
      eachGroupList.add((myData.data()["groupList"] as List<dynamic>)
          .firstWhere((element) => e == element));
    });

    // groupList の値を groupListController へ送る
    query.get().then((value) {
      groupListController.sink.add(value.data()["groupList"]);
    });

    print(["myData", myData]);
    print(["groupList", myData.data()["groupList"]]);

    loading.setLoading(false);


  }



}
