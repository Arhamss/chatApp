import 'package:chat_app/core/asset_names.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/chat/presentation/widgets/build_user_stories.dart';
import 'package:chat_app/features/chat/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatHomePage extends StatelessWidget {
  ChatHomePage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              addChat,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              readAll,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16,
        ),
        child: Column(
          children: [
            StoriesListView(),
            const Divider(
              color: Color(0xFFEDEDED),
            ),
            CustomSearchBar(
              controller: searchController,
              hintText: 'Placeholder',
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    return ListView.builder(
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];
                        return ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                image: AssetImage(arham),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(chat.name),
                          subtitle: Text(chat.lastMessage),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                chat.lastMessageTime.day == DateTime.now().day
                                    ? 'Today'
                                    : '${chat.lastMessageTime.day}/${chat.lastMessageTime.month}',
                              ),
                              const CircleAvatar(
                                radius: 12,
                                backgroundColor: Color(0xFFD2D5F9),
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    color: Color(0xFF001A83),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigate to chat page
                          },
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
