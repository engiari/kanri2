import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/loadingNotifier.dart';
import 'package:flutter_app7/screen/util/loginModel.dart';
import 'package:flutter_app7/screen/util/sharedDataController.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class DiaryBloc {
  final StreamController<bool> controller = StreamController<bool>();
  final LoadingNotifier loading;

  final CollectionReference query =
  FirebaseFirestore.instance.collection('feed');

  final formatter = new DateFormat('yyyy-MM');

  DiaryBloc(this.loading);

  referenceDiary({day, meal, condition, fatigue, appetite, defecation}) {
    // TODO submit
    loading.setLoading(true);
    query
        .get()
        .then((value) => Fluttertoast.showToast(
        msg: "データを取得しました",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0))
        .onError((error, stackTrace) =>
        Fluttertoast.showToast(
            msg: "データの取得に失敗しました",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0))
        .whenComplete(() => loading.setLoading(false));
  }
  
  getMonthData(){
    DateTime now = DateTime.now();
    query.orderBy("day").startAt([formatter.format(now)]).get().then((value) => print(value.docs.length));
  }
}
