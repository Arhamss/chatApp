import 'package:chat_app/core/asset_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatInputField extends StatelessWidget {
  ChatInputField({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            SvgPicture.asset(
              add,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                messageSend,
              ),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }
}
