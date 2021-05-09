import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/screen/routes/group/user_seach.dart';
import 'package:flutter_app7/screen/util/group_model.dart';

import 'add_group.dart';

enum TYPE { home, search}

class Group extends StatefulWidget {
  const Group({Key key, @required this.app}) : super(key: key);

  final FirebaseApp app;

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  TYPE pageType = TYPE.home;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('グループ'),
        leading: pageType != TYPE.home ? IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: backOperation(),
        ) : null,
      ),
      body: buildWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            pageType = TYPE.search;
          });
        },
        child: const Icon(Icons.add),
      ),
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

  Function backOperation() {
    switch (pageType) {
      case TYPE.search:
        return () {
          setState(() {
            pageType = TYPE.home;
          });
        };
        break;
      default:
        return null;
        break;
    }
  }

  Widget buildWidget() {
    switch (pageType) {
      case TYPE.home:
        return Column(
          children: <Widget>[
            Text('Group1'),
            Text('Group2'),
            Text('Group3'),
            Text('Group4'),
          ],
        );
        break;
      case TYPE.search:
        return UserSearch();
        break;
      default:
        return Container();
        break;
    }
  }
}
