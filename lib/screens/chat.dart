import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {
  final messages = <String>['Hi, I am near the station entrance.', 'Okay, I’m coming to the pickup point.'];
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _send() {
    if (controller.text.trim().isEmpty) return;
    setState(() => messages.add(controller.text.trim()));
    controller.clear();
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('Chat with Amit')),
        body: SafeArea(
          top: false,
          child: ContentWidth(
            maxWidth: 720,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, i) => Align(
                      alignment: i.isOdd ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: i.isOdd ? AppColors.navy : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Text(messages[i], style: TextStyle(color: i.isOdd ? Colors.white : AppColors.ink)),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onSubmitted: (_) => _send(),
                          decoration: const InputDecoration(hintText: 'Type a message'),
                        ),
                      ),
                      IconButton(onPressed: _send, icon: const Icon(Icons.send_rounded, color: AppColors.teal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
