import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final _formKey = GlobalKey<FormBuilderState>();

  String meal = '';

  int condition = 0;

  int fatigue = 0;

  int appetite = 0;

  int defecation = 0;

  String _condition = "";


  // テーブル指定
  CollectionReference query =
  FirebaseFirestore.instance.collection('feed');

  final now = DateTime.now();

  var formatter = new DateFormat('yyyy/MM/dd');

  void feed() {
    if (meal.isEmpty) {
      throw ('食事メニューを入力してください');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Scaffold(
      appBar: AppBar(
        title: Text("今日のコンディション"),
        actions: <Widget> [
          FlatButton(
            child: Text("送信"),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                // TODO submit
                await query
                    .add({
                  'meal': meal, // John Doe
                  'condition': _condition, // John Doe
                  'fatigue': fatigue, // Stokes and Sons
                  'appetite': appetite, // 42
                  'defecation': defecation, // 42
                });
                    //.then((value) => null).catchError(onError).whenComplete(() => null)
              }
            },
          ),
        ],
      ),
      body: ListView(
        // padding: const EdgeInsets.all(8),
        children: <Widget>[
          Text(formatter.format(now.toLocal())),
          Text("本日の食事メニューを入力してください"),
          Text("朝食"),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '食事メニュー',
            ),
            maxLines: null,
            onChanged: (String text) {
              meal = text;
            },
            validator: (String test) {
              if (test.isEmpty) {
                return ('食事メニューを入力してください');
              }
              return null;
            },
          ),
          Text("体調"),
          FormBuilderRadioGroup(
            onChanged: (text){_condition = text;},
            validator: (String text) {
              if (text == null) {
                return ('どれかを選択してください');
              }
              return null;
            },
            options: [
              "5", "4", "3", "2", "1",
            ]
                .map((option) => FormBuilderFieldOption(value: option))
                .toList(growable: false), name: "体調",
          )
        ],
      ),
    ),
    );
  }
}
