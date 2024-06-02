import 'package:chat_app/core/asset_names.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String receiverId;
  final VoidCallback onBack;

  ChatAppBar({
    required this.receiverId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset(
          leftArrow,
        ),
        onPressed: onBack,
      ),
      title: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is MessageLoaded) {
            return Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    state.user.photoUrl,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '${state.user.firstName} ${state.user.lastName}',
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            search,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            hamburger,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
