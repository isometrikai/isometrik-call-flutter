import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  static const String route = Routes.chat;

  @override
  Widget build(BuildContext context) => const Scaffold(
        appBar: CustomAppBar(label: 'Chats'),
        body: Center(
          child: Text('Feature in progress'),
        ),
      );
}
