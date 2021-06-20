import 'package:flutter/cupertino.dart';
import 'package:flutter_app7/model/user_data.dart';

class AddGroup extends StatelessWidget {
  final UserData data;

  const AddGroup({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Text(data.email);
  }
}