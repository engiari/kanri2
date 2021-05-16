import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_app7/bloc/feed_bloc.dart';
import 'package:flutter_app7/screen/util/loading_notifier.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  File _image;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }


  final _formKey = GlobalKey<FormBuilderState>();

  int timeframe = 0;

  String meal = '';

  int condition = 0;

  int fatigue = 0;

  int appetite = 0;

  int defecation = 0;

  List<String> _timeframe = [
    "",
    "",
    "",
  ];

  List<String> _meal = [
    "",
    "",
    "",
  ];

  List<String> _condition = [
    "",
    "",
    "",
  ];
  List<String> _fatigue = [
    "",
    "",
    "",
  ];
  List<String> _appetite = [
    "",
    "",
    "",
  ];
  List<String> _defecation = [
    "",
    "",
    "",
  ];

  List<bool> stateList = [true, false, false];

  // テーブル指定

  final now = DateTime.now();

  var formatter = new DateFormat('yyyy/MM/dd');

  FeedBloc feedBloc;

  void feed() {
    if (meal.isEmpty) {
      throw ('食事メニューを入力してください');
    }
  }

  Widget radioMenu(int index) {
    return Column(
      children: [
        Text("時間帯"),
        FormBuilderRadioGroup(
          wrapAlignment: WrapAlignment.center,
          onChanged: (text) {
            _timeframe[index] = text;
          },
          validator: (String text) {
            if (text == null) {
              return ('どれかを選択してください');
            }
            return null;
          },
          options: [
            "朝",
            "昼",
            "夜",
          ]
              .map((option) => FormBuilderFieldOption(value: option))
              .toList(growable: false),
          name: "時間帯",
        ),
        ListTile(
          title: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '食事メニュー',
            ),
            maxLines: null,
            onChanged: (String text) {
              _meal[index] = text;
            },
            validator: (String test) {
              return null;
            },
          ),
          //subtitle: Text("体調"),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: 300,
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(_image)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: getImageFromCamera, //カメラから画像を取得
                  tooltip: 'Pick Image From Camera',
                  child: Icon(Icons.add_a_photo),
                ),
                FloatingActionButton(
                  onPressed: getImageFromGallery, //ギャラリーから画像を取得
                  tooltip: 'Pick Image From Gallery',
                  child: Icon(Icons.photo_library),
                ),
              ],
            )
          ],
        ),
        Text("体調"),
        FormBuilderRadioGroup(
          wrapAlignment: WrapAlignment.center,
          onChanged: (text) {
            _condition[index] = text;
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
          wrapAlignment: WrapAlignment.center,
          onChanged: (text) {
            _fatigue[index] = text;
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
          wrapAlignment: WrapAlignment.center,
          onChanged: (text) {
            _appetite[index] = text;
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
          wrapAlignment: WrapAlignment.center,
          onChanged: (text) {
            _defecation[index] = text;
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
    );
  }

  bool isLording = false;

  @override
  Widget build(BuildContext context) {
    feedBloc = FeedBloc(Provider.of<LoadingNotifier>(context, listen: false));
    return FormBuilder(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("今日のコンディション"),
          /*
          actions: <Widget>[
            FlatButton(
              child: Text("送信"),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  feedBloc.sendFeed(
                      meal: _meal,
                      condition: _condition,
                      fatigue: _fatigue,
                      appetite: _appetite,
                      defecation: _defecation);
                }
              },
            ),
          ],

           */
        ),
        body: ListView(
          // padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              // 内側余白
              padding: EdgeInsets.all(1),
              // 外側余白
              margin: EdgeInsets.all(1),
            ),
            Text(
              formatter.format(now.toLocal()),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20.0,
                // 行間
                height: 1.1,
              ),
            ),
            /*
            Text("食事メニューを入力してください",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.0,
                  // 太文字
                  fontWeight: FontWeight.bold,
                  // 文字間隔
                  letterSpacing: 0.0,
                  // 行間
                  height: 1.3,
                )),
            //Text("朝食"),

             */

            /* FlatButton(
              child: Text("朝食"),
              onPressed: () {},
            ),
            */
            Container(
              // 内側余白
              padding: EdgeInsets.all(1),
              // 外側余白
              margin: EdgeInsets.all(1),
            ),
            Container(),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  stateList[index] = !isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text('食事内容とお身体の状態を入力してください',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                            // 太文字
                            fontWeight: FontWeight.bold,
                            // 文字間隔
                            letterSpacing: 0.0,
                            // 行間
                            height: 1.3,
                          )),
                    );
                  },
                  body: radioMenu(0),
                  isExpanded: stateList[0],

                ),
                /*
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text('昼食'),
                    );
                  },
                  body: radioMenu(1),
                  isExpanded: stateList[1],
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text('夕食'),
                    );
                  },
                  body: radioMenu(2),
                  isExpanded: stateList[2],
                ),

                 */
              ],
            ),
            FlatButton(
              color: Colors.blue,

              child:
              Text("記録する",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    // 太文字
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  feedBloc.sendFeed(
                      timeframe: _timeframe,
                      meal: _meal,
                      condition: _condition,
                      fatigue: _fatigue,
                      appetite: _appetite,
                      defecation: _defecation);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
