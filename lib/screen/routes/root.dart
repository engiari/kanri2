import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/routes/infoRoute.dart';
import 'package:flutter_app7/screen/routes/settingRoute.dart';
import 'package:flutter_app7/screen/routes/tokenMonitor.dart';
import 'diaryRoute.dart';
import 'feedRoute.dart';
import 'group/groupRoute.dart';
import 'homeRoute.dart';
import 'settingRoute.dart';

// 各ページ

class RootWidget extends StatefulWidget {
  RootWidget({Key? key}) : super(key: key);

  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  int _selectedIndex = 0;

  final _bottomNavigationBarItems = <BottomNavigationBarItem>[];

  static const _footerIcons = [
    Icons.home,
    Icons.article_outlined,
    Icons.auto_stories,
    Icons.people_outlined,
    Icons.error,
    Icons.miscellaneous_services,
  ];

  static const _footerItemNames = [
    'ホーム',
    'フィード',
    'ダイアリー',
    'グループ',
    'お知らせ',
    '設定',
  ];
  String? _token;

  var _routes = [
    Home(),
    Feed(),
    CustomContainerExample(), //Diary(),
    Group(),
    Info(), //Info(),
    Setting(),
  ];

  @override
  void initState() {
    super.initState();

    _bottomNavigationBarItems.add(_UpdateActiveState(0));

    for (var i = 1; i < _footerItemNames.length; i++) {
      _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
    }
  }

  BottomNavigationBarItem _UpdateActiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],
        color: Colors.black87,
      ),
      label: _footerItemNames[index],
    );
  }

  BottomNavigationBarItem _UpdateDeactiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],
        color: Colors.black26,
      ),
      //label: _footerItemNames[index] ?? "",
      label: _footerItemNames[index],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavigationBarItems[_selectedIndex] =
          _UpdateDeactiveState(_selectedIndex);
      _bottomNavigationBarItems[index] = _UpdateActiveState(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _routes.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // ４個以上表示させる
        unselectedItemColor: Theme.of(context).disabledColor,
        selectedItemColor: Theme.of(context).accentColor,
        items: _bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
