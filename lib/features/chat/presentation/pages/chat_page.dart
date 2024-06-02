import 'package:chat_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_appbar.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.chatId,
    required this.receiverId,
  });

  final String chatId;
  final String receiverId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
          LoadChatMessageEvent(
            widget.chatId,
            widget.receiverId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        onBack: () => Navigator.pop(context),
        receiverId: widget.receiverId,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                print(state);
                if (state is MessageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessageLoaded) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      bool isMe = message.senderId ==
                          FirebaseAuth.instance.currentUser!.uid;

                      return ChatMessageBubble(
                        message: message.text,
                        isMe: isMe,
                        time: DateFormat('HH:mm').format(
                          message.timestamp,
                        ),
                      );
                    },
                  );
                } else if (state is MessageError) {
                  return Center(child: Text(state.message));
                } else {
                  return Container();
                }
              },
            ),
          ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              // if (state is NavigateToChatScreen) {
              //   WidgetsBinding.instance.addPostFrameCallback((_) {
              //     Navigator.pushNamed(
              //       context,
              //       '/chatScreen',
              //       arguments: state.chatId,
              //     );
              //   });
              // }
              return ChatInputField(
                controller: _controller,
                onSend: () {
                  if (_controller.text.isNotEmpty && state is MessageLoaded) {
                    context.read<ChatBloc>().add(
                          SendMessageEvent(
                            widget.chatId,
                            FirebaseAuth.instance.currentUser!.uid,
                            _controller.text,
                            state.messages,
                          ),
                        );
                    _controller.clear();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
