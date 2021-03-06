import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/model/userData.dart';
import 'package:flutter_app7/screen/util/loadingNotifier.dart';
import 'package:flutter_app7/screen/util/loginModel.dart';
import 'package:flutter_app7/screen/util/sharedDataController.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class FeedBloc {
  final StreamController<bool> controller = StreamController<bool>();
  final LoadingNotifier loading;

  final CollectionReference query =
      FirebaseFirestore.instance.collection('feed');



  final formatter = new DateFormat('yyyy-MM-dd');

  FeedBloc(this.loading);

  sendFeed({uid, timeframe, meal, condition, fatigue, appetite, defecation}) {
    // TODO submit

    loading.setLoading(true);
    query
        .add({
          'uid': uid,
          'day': formatter.format(DateTime.now().toLocal()),
          'timeframe': timeframe,
          'meal': meal,
          'condition': condition,
          'fatigue': fatigue,
          'appetite': appetite,
          'defecation': defecation,
        })
        .then((value) => Fluttertoast.showToast(
            msg: "送信しました",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0))
        .onError((dynamic error, stackTrace) => Fluttertoast.showToast(
            msg: "送信失敗しました",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0))
        .whenComplete(() => loading.setLoading(false));
  }



}
