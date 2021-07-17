import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/routes/feedRoute.dart';
import 'package:flutter_app7/screen/routes/group/groupRoute.dart';
import 'package:flutter_app7/screen/util/loadingNotifier.dart';
import 'package:flutter_app7/screen/util/loginRoute.dart';
import 'package:flutter_app7/screen/routes/root.dart';
import 'package:flutter_app7/screen/util/sharedDataController.dart';
import 'package:flutter_app7/screen/util/signupRoute.dart';
import 'package:flutter_app7/screen/topRoute.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
/*
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("バックグラウンドでメッセージを受け取りました");
}


 */
// クラッシュレポート
Future<void> main() async {
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedDataController.init();
  /*
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _firebaseMessaging.requestPermission(
    sound: true,
    badge: true,
    alert: true,
  );
  _firebaseMessaging.getToken().then((String? token) {
    print("$token");
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("フォアグラウンドでメッセージを受け取りました");
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: 'launch_background',
            ),
          ));
    }
  });

   */
  runZonedGuarded(() {
    runApp(App());
  }, (error, stackTrace) {
    //print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class App extends StatelessWidget {
  String? userid = SharedDataController().getData().userId;

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
              //print("");
              //print(model.loadingFlag);
              return Stack(
                children: [
                  child!,
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
