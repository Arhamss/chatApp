import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/features/chat/presentation/bloc/bottom_nav_bar_bloc/bottom_nav_bar_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/bottom_nav_bar_bloc/bottom_nav_bar_event.dart';
import 'package:chat_app/features/chat/presentation/bloc/bottom_nav_bar_bloc/bottom_nav_bar_state.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({required this.shell, super.key});

  final StatefulNavigationShell shell;

  void _onItemTapped(BuildContext context, int index) {
    context.read<BottomNavBarBloc>().add(UpdateTabIndex(index));

    switch (index) {
      case 0:
        context.goNamed(AppRoute.contacts.name);

      case 1:
        context.goNamed(AppRoute.chatHome.name);

      case 2:
        context.goNamed(AppRoute.more.name);
    }
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isSelected)
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0F1828),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            )
          else
            SvgPicture.asset(iconPath),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              width: 6.0,
              height: 6.0,
              decoration: const BoxDecoration(
                color: Color(0xFF0F1828),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: BlocConsumer<BottomNavBarBloc, BottomNavBarState>(
        builder: (context, state) {
          int currentIndex = 1;
          if (state is BottomNavBarUpdated) {
            currentIndex = state.selectedIndex;
          }
          return BottomNavigationBar(
            currentIndex: currentIndex,
            backgroundColor: Colors.white,
            elevation: 20,
            onTap: (index) => _onItemTapped(context, index),
            items: [
              BottomNavigationBarItem(
                icon: _buildNavItem(
                  index: 0,
                  iconPath: 'assets/contacts.svg',
                  label: 'Contacts',
                  isSelected: currentIndex == 0,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(
                  index: 1,
                  iconPath: 'assets/chat.svg',
                  label: 'Chats',
                  isSelected: currentIndex == 1,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(
                  index: 2,
                  iconPath: 'assets/more.svg',
                  label: 'More',
                  isSelected: currentIndex == 2,
                ),
                label: '',
              ),
            ],
          );
        },
        listener: (BuildContext context, BottomNavBarState state) {
          if (state is BottomNavBarUpdated && state.selectedIndex == 1) {
            final userId = FirebaseAuth.instance.currentUser!.uid;
            context.read<ChatBloc>().add(LoadChatsEvent(userId));
          }
        },
      ),
    );
  }
}
