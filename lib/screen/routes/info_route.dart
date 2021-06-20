// @dart=2.9

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'message.dart';

/// Listens for incoming foreground messages and displays them in a list.
class Info extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Info();
}

class _Info extends State<Info> {
  List<RemoteMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _messages = [..._messages, message];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) {
      return const Text('No messages received');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("食事栄養管理アプリ BBF"),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            RemoteMessage message = _messages[index];

            return ListTile(
              title: Text(
                  message.messageId ?? 'no RemoteMessage.messageId available'),
              subtitle:
              Text(message.sentTime?.toString() ?? DateTime.now().toString()),
              onTap: () => Navigator.pushNamed(context, '/message',
                  arguments: MessageArguments(message, false)),
            );
          }),
    );
  }
}
