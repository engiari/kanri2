import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/bloc/loginBloc.dart';
import 'package:flutter_app7/screen/util/loadingNotifier.dart';
import 'package:flutter_app7/screen/util/loginModel.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  String _mail = "";
  String _password = "";
  LoginBloc? bloc;

  @override
  Widget build(BuildContext context) {
    bloc = LoginBloc(Provider.of<LoadingNotifier>(context, listen: false));

    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/");
          },
        ),
      ),
      body: Provider<LoginBloc?>(
        create: (context) => bloc,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<bool>(
            stream: bloc!.controller.stream,
            builder: (context, snapshot) {
              Widget errorWidget = Container();
              if (snapshot.hasError) errorWidget = Text(snapshot.error as String);
              if (!snapshot.hasData || !snapshot.data!)
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

                        // true の判定、画面遷移のコードを書く　ヒント：非同期
                        bloc!.login(_mail, _password);
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
