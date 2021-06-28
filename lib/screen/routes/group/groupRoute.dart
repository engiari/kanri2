import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/bloc/groupBloc.dart';
import 'package:flutter_app7/model/groupData.dart';
import 'package:flutter_app7/model/userData.dart';
import 'package:flutter_app7/screen/util/loadingNotifier.dart';
import 'package:provider/provider.dart';
import '../chatRoute.dart';

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
  String error = '';
  String groupName = '';
  String showGroupChat;
  GroupBloc groupBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupBloc.searchGroup();
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
        title: showGroupChat != null ? const Text('チャット'): const Text('グループ'),
        leading: showGroupChat != null ?
             IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: (){setState(() {
                  showGroupChat = null;
                });}
              )
            : null,
      ),
      body: showGroupChat != null ? Chat(showGroupChat): Column(
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
                        //print("data");
                        //print(snapshot.data.email);
                      },
                      child: Text('追加'),
                    ),
                  ],
                );
              return Column(
                children: <Widget>[
                  Container(
                    color: Colors.grey,
                    // 内側余白
                    padding: EdgeInsets.all(1),
                    // 外側余白
                    margin: EdgeInsets.all(20),
                  ),
                  Text("グループリスト",
                      style: TextStyle(color: Colors.black,fontSize: 15.0,)),
                ],
              );
            },
          ),

          StreamBuilder<List<GroupData>>(
            stream: groupBloc.groupListController.stream,
            builder: (context, snapshot) {
              //print(snapshot.data);
              if (snapshot.hasError) return Text("error");
              if (snapshot.hasData) {

                return Column(

                  //children: snapshot.data.map((dynamic e) => Text(e.toString())).toList(),
                    //children: groupBloc.searchGroup(searchGroup),

                    children: snapshot.data.map((GroupData e) => TextButton(onPressed: (){
                      setState(() {
                        showGroupChat = e.documentPath;
                      });
                    }, child: Text(e.groupName,
                        style: TextStyle(color: Colors.blue,fontSize: 30.0,)))).toList(),
                );
              }
              //print("グループリスト");
              //print(snapshot.data);
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
