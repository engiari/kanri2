import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/bloc/diary_bloc.dart';
import 'package:flutter_app7/screen/util/loading_notifier.dart';
import 'package:flutter_simple_customize_calendar/flutter_simple_customize_calendar.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

class CustomContainerExample extends StatefulWidget {
  @override
  _CustomContainerExampleState createState() => _CustomContainerExampleState();
}

class _CustomContainerExampleState extends State<CustomContainerExample> {
  CollectionReference query = FirebaseFirestore.instance.collection('feed');

  DiaryBloc diaryBloc;

  DateTime targetDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  var formatter = new DateFormat('yyyy/MM/dd');

  @override
  void initState() {
    super.initState();
    // レイアウトが
    WidgetsBinding.instance.addPostFrameCallback((_) {
      diaryBloc =
          DiaryBloc(Provider.of<LoadingNotifier>(context, listen: false));
      diaryBloc.getMonthData();
    });
  }

  Map<int, TextStyle> setDayTextStyle() {
    Map<int, TextStyle> style = {};

    for (int i = 1; i <= 7; i++) {
      switch (i) {
        case 7:
          style.putIfAbsent(
              i,
              () => TextStyle(
                    // 日曜日になる日の色
                    color: Colors.red,
                    fontSize: 15,
                  ));
          break;
        case 6:
          style.putIfAbsent(
              i,
              () => TextStyle(
                    // 土曜日になる日の色
                    color: Colors.blue,
                    fontSize: 15,
                  ));
          break;
        default:
          style.putIfAbsent(
              i,
              () => TextStyle(
                    // 平日になる日の色
                    color: Colors.black,
                    fontSize: 15,
                  ));
          break;
      }
    }
    return style;
  }

  // 曜日
  List<TextStyle> setWeekdayTextStyle() {
    List<TextStyle> style = [];

    for (int i = 0; i < 7; i++) {
      switch (i) {
        case 0:
          style.add(TextStyle(
            color: Colors.red,
            fontSize: 15,
          ));
          break;
        case 6:
          style.add(TextStyle(
            color: Colors.blue,
            fontSize: 15,
          ));
          break;
        default:
          style.add(TextStyle(
            color: Colors.black,
            fontSize: 15,
          ));
          break;
      }
    }
    return style;
  }

  Widget _getDayContainer(DateTime showDate, DateTime targetMonthDate,
      bool disable, Function(DateTime) onPressed) {
    return Expanded(
      child: Container(
        // 四方すべてに均等に余白
        padding: EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: SizedBox(
          // infinity = 可能な限り自身のWidgetのサイズを大きくする
          height: double.infinity,
          width: double.infinity,
          // アクティブ時の設定

          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: showDate.difference(targetDay).inDays == 0
                  ? Colors.blue
                  : Colors.transparent,
            ),
            child: Stack(
              children: <Widget>[
                // 当月以外の日の設定
                FlatButton(
                  disabledTextColor: Colors.black12,
                  textColor: showDate.difference(targetDay).inDays == 0
                      ? Colors.white
                      : targetMonthDate.month == showDate.month
                          ? setDayTextStyle()[showDate.weekday].color
                          : Colors.grey,
                  onPressed: disable
                      ? null
                      : () {
                          onPressed(showDate);
                        },
                  child: Text(
                    '${showDate.day}',
                  ),
                ),
                showDate ==
                        // 今日の日付から２日後
                        DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day + 2)
                    ? Align(
                        // 子Widgetの配置
                        alignment: Alignment.bottomRight,
                        //child: Icon(Icons.assignment_ind),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getHeader(DateTime targetDate, bool prevDisable, bool nextDisable,
      DateTime currentMonth, Function() onLeftPressed, onRightPressed) {
    // 月変更ボタン
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: prevDisable
              ? null
              : () {
                  onLeftPressed();
                },
          child: Icon(Icons.arrow_back_ios),
        ),
        Text('${DateFormat.yM('ja').format(currentMonth)}'),
        FlatButton(
          onPressed: nextDisable
              ? null
              : () {
                  onRightPressed();
                },
          child: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  Widget makeFutureBuilder(DateTime date) {
    return FutureBuilder<QuerySnapshot>(
      future: query.where("day", isEqualTo: formatter.format(date)).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Text("Something went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.docs.isNotEmpty) {
            Map<String, dynamic> data = snapshot.data.docs.first.data();
            return Scaffold(
              body: Text("Full Name: ${data["condition"][0]} ${data["condition"][1]}"),
              //body: Text("Full Name: ${data["userid"]} ${data["username"]} ${data["day"]}"),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("登録がありません",style: TextStyle(fontSize: 20.0),),
                    RaisedButton(
                      child: Text('戻る'),
                      onPressed: () =>
                          Navigator.of(context).pop('戻る'),
                    ),
                  ],
                ),
              ),
            );

          }
        }

        return Scaffold(
          body: Text("loading"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ダイアリー'),
      ),
      body: Center(
        child: FlutterSimpleCustomizeCalendar(
          locale: 'ja',
          dayTextStyle: setDayTextStyle(),
          limitMinDate: DateTime(DateTime.now().year, DateTime.now().month - 1,
              DateTime.now().day),
          limitMaxDate: DateTime(DateTime.now().year, DateTime.now().month + 1,
              DateTime.now().day),
          disableTextStyle: TextStyle(
            color: Colors.black12,
          ),
          weekdayTextStyle: setWeekdayTextStyle(),
          // 日付をタップした時の動作
          onDayPressed: (DateTime date) {
            print(date);
            setState(() {
              targetDay = date;
            });

            query
                .where("day", isEqualTo: formatter.format(date))
                .get()
                .then((value) {
              print(value.docs.first);
            });

            // 日付をタップした時にダイアログ　以下の項目表示
            showDialog(
              context: context,
              builder: (context) {
                return makeFutureBuilder(date);
              },
            );
          },
          dayWidget: _getDayContainer,
          headerWidget: _getHeader,
          targetDay: targetDay,
          firstWeekday: 0,
        ),
      ),
    );
  }
}
