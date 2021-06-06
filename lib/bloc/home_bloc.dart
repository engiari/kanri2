import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/loading_notifier.dart';
import 'package:flutter_app7/screen/util/login_model.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class HomeBloc {
  final StreamController<bool> controller = StreamController<bool>();
  final LoadingNotifier loading;

  final CollectionReference query =
  FirebaseFirestore.instance.collection('user');


  HomeBloc(this.loading);

  referenceHome({targetWeight}) {
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


}
