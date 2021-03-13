import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class Feed extends ChangeNotifier {
  String meal = '';
  int condition = 0;
  int fatigue = 0;
  int appetite = 0;
  int defecation = 0;

  get _condition => null;

  void _handleRadioButton(String condition) => setState(() { _condition = condition; } );

  final now = DateTime.now();

  Future feed() async {
    if (meal.isEmpty) {
      throw ('食事メニューを入力してください');
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("今日のコンディション"),
        ),
        body: ListView(
          // padding: const EdgeInsets.all(8),
          children: <Widget>[
            Text("$now"),
            Text("本日の食事メニューを入力してください"),
            Text("朝食"),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '食事メニュー',
              ),
              maxLines: null,
            ),
            Text("体調"),
            Row(
              children: <Widget>[
                Radio(
                  activeColor: Colors.blueAccent,
                  value: '5',
                  groupValue: _condition,
                  onChanged: _handleRadioButton,
                ),
                Radio(
                  activeColor: Colors.blueAccent,
                  value: '4',
                  groupValue: _condition,
                  onChanged: _handleRadioButton,
                ),
                Radio(
                  activeColor: Colors.blueAccent,
                  value: '3',
                  groupValue: _condition,
                  onChanged: _handleRadioButton,
                ),
                Radio(
                  activeColor: Colors.blueAccent,
                  value: '2',
                  groupValue: _condition,
                  onChanged: _handleRadioButton,
                ),
                Radio(
                  activeColor: Colors.blueAccent,
                  value: '1',
                  groupValue: _condition,
                  onChanged: _handleRadioButton,
                ),
              ],
            ),
          ],
        ),
      );
    }

    // todo
    FirebaseFirestore.instance.collection('feed').add(
      {
        'meal': meal,
        'createdAt': Timestamp.now(),
      },
    );
  }
}
