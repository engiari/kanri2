import 'package:flutter/material.dart';
import 'root.dart';
import 'routes/Top_route.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: RootWidget(),
      initialRoute: '/',
      routes: {
        //   '/routes/talk_route': (context) => TalkRoute(),
      },
    );
  }
}

