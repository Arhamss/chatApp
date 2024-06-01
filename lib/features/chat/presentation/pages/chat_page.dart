import 'package:chat_app/features/chat/presentation/widgets/chat_appbar.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chatId});

  final String chatId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    final messageText = _controller.text;
    if (messageText.isNotEmpty) {
      final user = _auth.currentUser;
      await _firestore.collection('chats').add({
        'text': messageText,
        'senderId': user!.uid,
        'senderName': user.displayName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        userName: 'Athalia Putri',
        userImageUrl: 'https://example.com/user.jpg',
        onBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == _auth.currentUser!.uid;
                    return ChatMessageBubble(
                      message: message['text'].toString(),
                      isMe: isMe,
                      time: message['timestamp'] != null
                          ? (message['timestamp'] as Timestamp)
                              .toDate()
                              .toLocal()
                              .toString()
                              .substring(11, 16)
                          : '',
                      isRead: false,
                      // Update this if you have read receipt logic
                      isImage: false,
                      imageUrl: null,
                    );
                  },
                );
              },
            ),
          ),
          ChatInputField(
            controller: _controller,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
