import 'package:chat_app/core/asset_names.dart';
import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/core/widgets/asset_image_widget.dart';
import 'package:chat_app/core/widgets/search_bar.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_home_bloc/chat_home_bloc.dart';
import 'package:chat_app/features/chat/presentation/widgets/build_user_stories.dart';
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatHomeView extends StatelessWidget {
  ChatHomeView({super.key});

  final TextEditingController searchController = TextEditingController();

  String findNumber(String PartiipantId, List<UserEntity> userEntityUserEntities){

      for (var i = 0; i < userEntityUserEntities.length; i++) {
        if(PartiipantId == userEntityUserEntities[i].id){
          return userEntityUserEntities[i].phoneNumber;
        }
      }
      return '';

    }
//REVIEW - - -  -  have to correct the name logic here for the push notification title

  
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
            icon: const AssetImageWidget(
              assetPath: addChat,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const AssetImageWidget(
              assetPath: readAll,
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
              hintText: 'Search for chats',
            ),
            Expanded(
              child: BlocConsumer<ChatHomeBloc, ChatHomeState>(
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
                              image: DecorationImage(
                                image: NetworkImage(
                                  state.users[index].photoUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            '${state.users[index].firstName} ${state.users[index].lastName}',
                          ),
                          subtitle: Text(chat.lastMessage),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                chat.lastMessageTime.day == DateTime.now().day
                                    ? DateFormat('HH:mm').format(
                                        chat.lastMessageTime,
                                      )
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
                            final phoneNumber = findNumber(chat.participants[1], state.users);


                            context.read<ChatHomeBloc>().add(
                                  NavigationToChatScreenEvent(
                                    chat.id,
                                    phoneNumber,
                                    chat.participants[1],
                                  ),
                                );
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
                listener: (BuildContext context, ChatHomeState state) {
                  if (state is NavigateToChatScreen) {
                    context.read<ChatHomeBloc>().add(
                          LoadChatsEvent(
                            FirebaseAuth.instance.currentUser!.uid,
                          ),
                        );
                    context.goNamed(
                      AppRoute.chat.name,
                      queryParameters: {
                        'chatId': state.chatId,
                        'phoneNumber': state.phoneNumber,
                        'receiverId': state.receiverId,
                      },
                    );
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
