import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app7/model/user_data.dart';
import 'package:flutter_app7/screen/routes/group/add_group.dart';

enum ADD_GROUP_TYPE { search, add }

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  ADD_GROUP_TYPE pageType = ADD_GROUP_TYPE.search;
  String targetEmail = '';
  UserData userData;
  String error;
  final textController = TextEditingController();

  _searchUser() {
    if (targetEmail.isEmpty) {
      setState(() {
        error = "Emailを入力してください。";
      });
      return;
    }
    CollectionReference query = FirebaseFirestore.instance.collection('user');
    query
        .where("email",
            isEqualTo: targetEmail,
            isNotEqualTo: FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      userData = UserData(
        uid: value.docs.first.data()['uid'],
        displayName: value.docs.first.data()['displayName'],
        email: value.docs.first.data()['email'],
      );

      /*
      userData = UserData()
      ..uid = value.docs.first.data()['uid']
      ..displayName = value.docs.first.data()['displayName']
      ..email = value.docs.first.data()['email'];
       */
      setState(() {
        pageType = ADD_GROUP_TYPE.add;
      });
    }).onError((error, stackTrace) => null);
  }

  @override
  Widget build(BuildContext context) {
    return buildWidget();
  }

  Widget buildWidget() {
    switch (pageType) {
      case ADD_GROUP_TYPE.search:
        return Column(
          children: [
            error != null && error != '' ? Text(error) : Container(),
            TextField(
              decoration: InputDecoration(
                hintText: 'sample@example.com',
              ),
              controller: textController,
              onChanged: (text) {
                targetEmail = text;
              },
            ),
            TextButton(
              onPressed: _searchUser,
              child: Text('検索する'),
            ),
          ],
        );
        break;
      case ADD_GROUP_TYPE.add:
        return AddGroup(
          data: userData,
        );
        break;
      default:
        return Container();
        break;
    }
  }
}
