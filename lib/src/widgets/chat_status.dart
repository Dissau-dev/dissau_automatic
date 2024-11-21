import 'package:flutter/material.dart';

class ChatStatus extends StatelessWidget {
  final bool isConnected;
  final String chatId;

  ChatStatus({required this.isConnected, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isConnected && chatId.isNotEmpty ? Colors.green : Colors.red,
          ),
        ),
        SizedBox(width: 8),
        Text(
          isConnected && chatId.isNotEmpty ? 'Connected' : 'Disconnected',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
