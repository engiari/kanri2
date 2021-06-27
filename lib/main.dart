import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/routes/feedRoute.dart';
import 'package:flutter_app7/screen/routes/group/groupRoute.dart';
import 'package:flutter_app7/screen/util/loadingNotifier.dart';
import 'package:flutter_app7/screen/util/login_route.dart';
import 'package:flutter_app7/screen/routes/root.dart';
import 'package:flutter_app7/screen/util/sharedDataController.dart';
import 'package:flutter_app7/screen/util/signupRoute.dart';
import 'package:flutter_app7/screen/topRoute.dart';
import 'package:provider/provider.dart';


// クラッシュレポート
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
      home: ChangeNotifierProvider(
        create:  (context) => LoadingNotifier(),
        child: Consumer<LoadingNotifier>(
            child: MaterialApp(
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
                '/feed_route': (context) => Feed(),
                '/group/group_route': (context) => Group(),

              },
            ),
            builder: (context, model, child) {
              // print("ccccccccccccccc");
              print(model.loadingFlag);
              return Stack(
                children: [
                  child,
                  model.loadingFlag ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.shade50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ) : Container(),
                ],
              );
            }
        ),
      ),
    );
  }
}
