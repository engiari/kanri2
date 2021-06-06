import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app7/screen/util/signup_model.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final userHeightController = TextEditingController();
    final userWeightController = TextEditingController();
    final userBodyBatPercentageController = TextEditingController();
    final userRegularController = TextEditingController();
    final targetWeightController = TextEditingController();

    String gender = '';

    return ChangeNotifierProvider<SignUpModel>(
      create: (_) => SignUpModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('新規登録'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
        ),
        body: Consumer<SignUpModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'sample@example.com',
                    ),
                    controller: mailController,
                    onChanged: (text) {
                      model.mail = text;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'パスワード',
                    ),
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (text) {
                      model.password = text;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'お名前',
                    ),
                    controller: nameController,
                    onChanged: (text) {
                      model.userName = text;
                    },
                  ),
                  Text('生年月日'),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.calendarAlt,
                        color: Colors.blue, size: 30.0),
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime(2049, 12, 31),
                        /*
                          onConfirm: (date) {
                            setState(() {
                              targetday = date;
                            });
                            initData(); //新しい日付でデータを再取得する
                          },
                          currentTime: targetday, locale: LocaleType.jp
                           */
                      );
                    },
                  ),
                  Container(
                    height: 30,
                  ),
                  Text("性別"),
                  FormBuilderRadioGroup(
                    wrapAlignment: WrapAlignment.center,
                    onChanged: (text) {
                      gender = text;
                    },
                    validator: (String text) {
                      if (gender == null) {
                        return ('どれかを選択してください');
                      }
                      return null;
                    },
                    options: [
                      "男",
                      "女",
                    ]
                        .map((option) => FormBuilderFieldOption(value: option))
                        .toList(growable: false),
                    name: "性別",
                  ),
                  TextField(
                    // 入力を数値のみに制限(カンマ,ピリオド,文字ペーストは可能)
                    keyboardType: TextInputType.number,
                    // 入力を完全に数値のみに制限
                    //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '身長(cm)',
                    ),
                    controller: userHeightController,
                    onChanged: (text) {
                      model.userHeight = text;
                    },
                  ),
                  TextField(
                    // 入力を数値のみに制限(カンマ,ピリオド,文字ペーストは可能)
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '体重(kg)',
                    ),
                    controller: userWeightController,
                    onChanged: (text) {
                      model.userWeight = text;
                    },
                  ),
                  TextField(
                    // 入力を数値のみに制限(カンマ,ピリオド,文字ペーストは可能)
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '体脂肪率(%)',
                    ),
                    controller: userBodyBatPercentageController,
                    onChanged: (text) {
                      model.userBodyBatPercentage = text;
                    },
                  ),
                  Text("定期的に摂取しているものがあれば入力してください"),
                  Container(
                    child: TextField(
                        decoration: InputDecoration(
                          hintText: 'サプリメント２錠など',
                        ),
                        controller: userRegularController,
                        onChanged: (text) {
                          model.userRegular = text;
                        },
                        style: TextStyle(height: 2.0, color: Colors.black)),
                  ),
                  Container(
                    child: TextField(
                      // 入力を数値のみに制限(カンマ,ピリオド,文字ペーストは可能)
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '目標体重',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      controller: targetWeightController,
                      onChanged: (text) {
                        model.targetWeight = text;
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text('登録する'),
                    onPressed: () async {
                      try {
                        await model.signUp();
                        _showDialog(context, '登録完了しました');
                        Navigator.of(context).pushReplacementNamed("/home_route");
                      } catch (e) {
                        _showDialog(context, e.toString());
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future _showDialog(
    BuildContext context,
    String title,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
