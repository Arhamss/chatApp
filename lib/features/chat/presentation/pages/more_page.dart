import 'package:chat_app/core/asset_names.dart';

import 'package:chat_app/features/chat/presentation/widgets/menu_item.dart';
import 'package:chat_app/features/chat/presentation/widgets/profile_section.dart';

import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  MorePage({super.key});

  final TextEditingController searchController = TextEditingController();

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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ProfileSection(
            avatarAsset: account,
            name: 'Arham Imran',
            phoneNumber: '+92 3014189946',
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
      ),
    );
  }
}
