import 'package:flutter/material.dart';
import 'package:flutter_simple_customize_calendar/flutter_simple_customize_calendar.dart';
import 'package:intl/intl.dart' show DateFormat;

class CustomContainerExample extends StatefulWidget {
  @override
  _CustomContainerExampleState createState() => _CustomContainerExampleState();
}

class _CustomContainerExampleState extends State<CustomContainerExample> {
  DateTime targetDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
          onDayPressed: (DateTime date) {
            print(date);
            setState(() {
              targetDay = date;
            });
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
