import 'package:chat_app/core/asset_names.dart';
import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/features/more/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:chat_app/features/more/presentation/widgets/menu_item.dart';
import 'package:chat_app/features/more/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is AuthSuccess){
            context.goNamed(
                AppRoute.landing.name,
            );
          }
        },
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
                MenuItem(
                    iconAsset: account,
                    title: 'Sign Out',
                    onPressed: (){
                      context.read<AuthBloc>().add(
                          const SignOutUserEvent(),
                      );
                    },
                  ),
                // SwitchListTile(
                //   title: const Text('asdasdsad'),
                //   value: true,
                //   onChanged: (bool value) {
                //     print('hey bro');
                //   },
                //   secondary: Icon(
                //     Icons.dark_mode,
                //   ),
                // ),
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12, right: 0),
                      child: SwitchListTile(
                        title: const Text('Dark Mode'),
                        value: themeState.themeMode == ThemeMode.dark,
                        onChanged: (bool value) {
                          context.read<ThemeBloc>().add(ToggleThemeEvent());
                        },
                        secondary: Icon(
                          themeState.themeMode == ThemeMode.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                      ),
                    );
                  },
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
