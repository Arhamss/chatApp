import 'package:chat_app/core/asset_names.dart';
import 'package:chat_app/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({required this.child, super.key});

  final Widget child;

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go(routeMap[AppRoute.chat]!);
      case 1:
        context.go(routeMap[AppRoute.chatHome]!);
      case 2:
        // Add navigation for the third tab if necessary
        break;
    }
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;
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
      body: PageStorage(
        bucket: PageStorageBucket(),
        child: widget.child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        elevation: 20,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon:
                _buildNavItem(index: 0, iconPath: contacts, label: 'Contacts'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(index: 1, iconPath: chat, label: 'Chats'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(index: 2, iconPath: more, label: 'More'),
            label: '',
          ),
        ],
      ),
    );
  }
}
