import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



/// Message route arguments.
class Info extends StatefulWidget {

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Text("FCMテスト"),
    ],
        )));
  }
}