import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/bloc/login_bloc.dart';
import 'package:flutter_app7/screen/util/login_model.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();
    final LoginBloc bloc = LoginBloc();
    String _mail = "";
    String _password = "";

    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: bloc.controller.stream,
          builder: (context, snapshot) {
            Widget errorWidget = Container();
            if (snapshot.hasError) errorWidget = Text(snapshot.error);
            if (!snapshot.hasData || !snapshot.data)
              return Column(
                children: <Widget>[
                  errorWidget,
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'sample@example.com',
                    ),
                    controller: mailController,
                    onChanged: (text) {
                      _mail = text;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'パスワード',
                    ),
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (text) {
                      _password = text;
                    },
                  ),
                  RaisedButton(
                    child: Text('ログインする'),
                    onPressed: () async {
                      print(_mail);
                      print(_password);
                      bloc.login(_mail, _password);
                    },
                  ),
                ],
              );
            return Container(
              child: Column(
                children: [
                  Text("ログインしました。"),
                  MaterialButton(
                    child: Text("Homeへ"),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("/home_route");
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future _showDialog(
    BuildContext context,
    String title,
  ) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
}
