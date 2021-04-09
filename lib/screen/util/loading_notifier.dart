import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';
import 'package:get_it/get_it.dart';

class LoadingNotifier extends ChangeNotifier {


  bool loadingFlag;
  static GetIt get it => GetIt.I;

  LoadingNotifier({this.loadingFlag});

  set setLoading(bool flag) {
    loadingFlag = flag;
  }

  static void init() {
    it.registerSingleton<LoadingNotifier>(LoadingNotifier(loadingFlag: false));
  }
  get loading => loadingFlag;
}
