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
  String _fatigue = "";
  String _appetite = "";
  String _defecation = "";

  // テーブル指定
  CollectionReference query = FirebaseFirestore.instance.collection('feed');

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
          actions: <Widget>[
            FlatButton(
              child: Text("送信"),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  // TODO submit
                  await query.add({
                    'meal': meal,
                    'condition': _condition,
                    'fatigue': _fatigue,
                    'appetite': _appetite,
                    'defecation': _defecation,
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

            /* FlatButton(
              child: Text("朝食"),
              onPressed: () {},
            ),
            */

            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {},
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text('朝食'),
                    );
                  },
                  body: ListTile(
                    title: TextFormField(
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
                    subtitle: Text("体調"),

                  ),
                  isExpanded: true,
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text('昼食'),
                    );
                  },
                  body: ListTile(
                    title: Text(''),
                    subtitle: Text(''),
                  ),
                  isExpanded: true,
                ),
              ],
            ),
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
              onChanged: (text) {
                _condition = text;
              },
              validator: (String text) {
                if (text == null) {
                  return ('どれかを選択してください');
                }
                return null;
              },
              options: [
                "5",
                "4",
                "3",
                "2",
                "1",
              ]
                  .map((option) => FormBuilderFieldOption(value: option))
                  .toList(growable: false),
              name: "体調",
            ),
            Text("疲労度"),
            FormBuilderRadioGroup(
              onChanged: (text) {
                _fatigue = text;
              },
              validator: (String text) {
                if (text == null) {
                  return ('どれかを選択してください');
                }
                return null;
              },
              options: [
                "5",
                "4",
                "3",
                "2",
                "1",
              ]
                  .map((option) => FormBuilderFieldOption(value: option))
                  .toList(growable: false),
              name: "疲労度",
            ),
            Text("食欲"),
            FormBuilderRadioGroup(
              onChanged: (text) {
                _appetite = text;
              },
              validator: (String text) {
                if (text == null) {
                  return ('どれかを選択してください');
                }
                return null;
              },
              options: [
                "5",
                "4",
                "3",
                "2",
                "1",
              ]
                  .map((option) => FormBuilderFieldOption(value: option))
                  .toList(growable: false),
              name: "食欲",
            ),
            Text("便"),
            FormBuilderRadioGroup(
              onChanged: (text) {
                _defecation = text;
              },
              validator: (String text) {
                if (text == null) {
                  return ('どれかを選択してください');
                }
                return null;
              },
              options: [
                "5",
                "4",
                "3",
                "2",
                "1",
              ]
                  .map((option) => FormBuilderFieldOption(value: option))
                  .toList(growable: false),
              name: "便",
            ),
          ],
        ),
      ),
    );
  }
}
