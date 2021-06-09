import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/bloc/group_bloc.dart';
import 'package:flutter_app7/model/user_data.dart';
import 'package:flutter_app7/screen/util/group_model.dart';
import 'package:flutter_app7/screen/util/loading_notifier.dart';
import 'package:provider/provider.dart';

import 'add_group.dart';

enum TYPE { home, search }

class Group extends StatefulWidget {
  const Group({Key key, @required this.app}) : super(key: key);

  final FirebaseApp app;

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  TYPE pageType = TYPE.home;
  final textController = TextEditingController();
  final groupController = TextEditingController();
  final StreamController<UserData> controller = StreamController<UserData>();
  final StreamController<List<dynamic>> groupListController =
  StreamController<List<dynamic>>();

  String searchEmail = '';
  String searchGroup = '';
  GroupBloc groupBloc;
  String error = '';
  String groupName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupBloc.searchGroup();
      //groupBloc.listGroup;
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (groupBloc == null) {
      groupBloc =
          GroupBloc(Provider.of<LoadingNotifier>(context, listen: false));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('グループ'),
        leading: pageType != TYPE.home
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: null,
              )
            : null,
      ),
      body: Column(
        children: <Widget>[
          // グループ名の表示
          TextField(
            decoration: InputDecoration(
              hintText: 'グループ登録したいメールアドレス',
            ),
            controller: textController,
            onChanged: (text) {
              searchEmail = text;
            },
          ),
          Text(error, style: TextStyle(color: Colors.red)),
          FlatButton(
            color: Colors.blue,
            child: Text("検索する",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  // 太文字
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () async {
              if (searchEmail.isEmpty) {
                setState(() {
                  error = "Emailを入力してください";
                });
                return;
              }
              setState(() {
                error = "";
              });
              groupBloc.searchUser(searchEmail);
            },
          ),
          StreamBuilder<UserData>(
            stream: groupBloc.controller.stream,
            builder: (context, snapshot) {
              Widget errorWidget = Container();
              if (snapshot.hasError)
                errorWidget =
                    Text(snapshot.error, style: TextStyle(color: Colors.red));
              if (snapshot.hasData)
                return Column(
                  children: [
                    Text("一致したメールアドレス"),
                    Text(snapshot.data.email,
                        style: TextStyle(color: Colors.red)),
                    TextField(
                      decoration: InputDecoration(
                        hintText: '分かりやすいグループ名を登録しましょう',
                      ),
                      controller: groupController,
                      onChanged: (text) {
                        groupName = text;
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        snapshot.data.groupName = groupName;
                        groupBloc.sendGroup(userData: snapshot.data);
                        print("data");
                        print(snapshot.data.email);
                      },
                      child: Text('追加'),
                    ),
                  ],
                );
              return Column(
                children: <Widget>[
                  Text(""),
                ],
              );
            },
          ),

          StreamBuilder<List<dynamic>>(
            stream: groupBloc.groupListController.stream,
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasError) return Text("error");
              if (snapshot.hasData) {

                return Column(
                  //children: snapshot.data.map((dynamic e) => Text(e.toString())).toList(),
                    //children: groupBloc.searchGroup(searchGroup),
                  children: snapshot.data.map((dynamic e) => Text(e.toString())).toList(),

                );

              }
              print("snapshot.hasData");
              print(snapshot.hasData);
              return Container();
            },
          ),
        ],
      ),

      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            pageType = TYPE.search;
          });
        },
        child: const Icon(Icons.add),
      ),
       */
    );

    /*
          ListTile(
            leading: Checkbox(
              onChanged: (bool value) {
                if (value != null) {
                  setState(() {
                    _anchorToBottom = value;
                  });
                }
              },
              value: _anchorToBottom,
            ),
            title: const Text('Anchor to bottom'),
          ),
          */
  }
}
