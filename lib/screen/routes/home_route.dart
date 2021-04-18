import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/login_model.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';

class Home extends StatelessWidget {
  LoginModel get sharedData => SharedDataController().getData();
  Query query =
  FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("食事栄養管理アプリ BBF"),
      ),

      body: ListView(
        // padding: const EdgeInsets.all(8),
        children: <Widget>[
          Text(
            FirebaseAuth.instance.currentUser.email,
            style: Theme.of(context).textTheme.headline4,

          ),
          RaisedButton(onPressed: () async {
            await query.get().then((querySnapshot) async {
              print (querySnapshot.docs.first.data());
            });
          })
        ],
      ),
    );
  }
}