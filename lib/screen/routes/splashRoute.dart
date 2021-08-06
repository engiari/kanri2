import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Splash extends StatefulWidget {


  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
    Future.delayed(Duration(milliseconds: 3000)).then((_) {
      print("sample");
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context)
            .pushReplacementNamed("/home_route");
      }
      else {
        Navigator.of(context)
            .pushReplacementNamed("/top");
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Material();
  }
}
