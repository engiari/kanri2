import 'dart:async';

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
          documentId: value.docs.first.id
      );
      controller.sink.add(userData);
    }).whenComplete(() => loading.setLoading(false));
  }
  sendGroup({UserData userData}) {
    // TODO submit
    final CollectionReference query =
    FirebaseFirestore.instance.collection('group');

    loading.setLoading(true);
    query
        .add({
      'uid_list': [
        FirebaseAuth.instance.currentUser.uid,userData.uid
      ],
    }).then((value) {

      FirebaseFirestore.instance.collection('user').doc(userData.documentId).set(
          {
            'group_list': FieldValue.arrayUnion([value.path]),

          },
          SetOptions(merge: true)
      );
    })
        .then((value) => Fluttertoast.showToast(
        msg: "追加しました",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0))
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

}
