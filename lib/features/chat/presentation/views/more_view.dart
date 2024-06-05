import 'package:chat_app/core/asset_names.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/features/chat/presentation/widgets/menu_item.dart';
import 'package:chat_app/features/chat/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'More',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [
          SizedBox.shrink(),
          SizedBox.shrink(),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading || state is FetchingUserDetailsState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserDetailsFetchedState) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                ProfileSection(
                  avatarAsset: state.userDetails.photoUrl,
                  name:
                      '${state.userDetails.firstName} ${state.userDetails.lastName}',
                  phoneNumber: state.userDetails.phoneNumber,
                ),
                const Divider(color: Color(0xFFEDEDED)),
                MenuItem(
                  iconAsset: account,
                  title: 'Account',
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: chat,
                  title: 'Chats',
                  onPressed: () {},
                ),
                const Divider(color: Color(0xFFEDEDED)),
                MenuItem(
                  iconAsset: appearance,
                  title: 'Appearance',
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: notification,
                  title: 'Notification',
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: privacy,
                  title: 'Privacy',
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: dataUsage,
                  title: 'Data Usage',
                  onPressed: () {},
                ),
                const Divider(color: Color(0xFFEDEDED)),
                MenuItem(
                  iconAsset: help,
                  title: 'Help',
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: inviteFriends,
                  title: 'Invite Your Friends',
                  onPressed: () {},
                ),
              ],
            );
          } else if (state is AuthError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }
}
