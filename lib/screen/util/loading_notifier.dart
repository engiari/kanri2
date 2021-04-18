import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';

class LoadingNotifier extends ChangeNotifier {
  bool loadingFlag = false;

  void setLoading(bool flag) {
    loadingFlag = flag;
    notifyListeners();
  }

}
