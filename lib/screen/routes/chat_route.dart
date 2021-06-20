import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/login_model.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';

class Chat extends StatefulWidget {
  String chatGroupPath;

  Chat(this.chatGroupPath);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Container(),
    );
  }
}
