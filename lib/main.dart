import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/util/login_route.dart';
import 'package:flutter_app7/screen/routes/root.dart';
import 'package:flutter_app7/screen/util/shared_data_controller.dart';
import 'package:flutter_app7/screen/util/signup_route.dart';
import 'package:flutter_app7/screen/top_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedDataController.init();
  runZonedGuarded(() {
    runApp(App());
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class App extends StatelessWidget {
  String userid = SharedDataController().getData().userId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => Top(),
        '/home_route': (context) => RootWidget(),
        '/login_route': (context) => LoginPage(),
        '/signup_route': (context) => SignUpPage(),
      },
    );
  }
}
