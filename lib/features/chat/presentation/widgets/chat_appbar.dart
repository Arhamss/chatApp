import 'package:chat_app/core/asset_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userImageUrl;
  final VoidCallback onBack;

  ChatAppBar({
    required this.userName,
    required this.userImageUrl,
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
      title: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage(arham),
          ),
          const SizedBox(width: 10),
          Text(userName),
        ],
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
