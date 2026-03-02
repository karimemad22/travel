import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = 'chat';

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: const Center(
        child: Text('Chat Screen'),
      ),
    );
  }
}
