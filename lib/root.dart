import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 各ページ
import 'routes/Top_route.dart';

class RootWidget extends StatefulWidget {
  RootWidget({Key key}) : super(key: key);

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
  ];

  static const _footerItemNames = [
    'ホーム',
    'フィード',
    'ダイアリー',
    'グループ',
    'お知らせ',
  ];

  var _routes = [
    Top(),
    Top(), //Home(),
    Top(), //Feed(),
    Top(), //Diary(),
    Top(), //Group(),
    Top(), //Info(),
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
        label: _footerItemNames[index],);
  }

  BottomNavigationBarItem _UpdateDeactiveState(int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          _footerIcons[index],
          color: Colors.black26,
        ),
        label: _footerItemNames[index] ?? "",);
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
