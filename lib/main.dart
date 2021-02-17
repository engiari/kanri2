import 'package:flutter/material.dart';
import 'package:flutter_app7/routes/login_route.dart';
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
      initialRoute: '/',
      routes: {
        '/' : (context) => RootWidget(),
        '/login_route': (context) => Talk(),
      },
    );
  }
}

