import 'package:chat_app/core/asset_names.dart';
import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/features/locale/bloc/locale_bloc.dart';
import 'package:chat_app/features/more/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:chat_app/features/more/presentation/widgets/menu_item.dart';
import 'package:chat_app/features/more/presentation/widgets/profile_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('more'),
          style: const TextStyle(
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
          if (state is AuthSuccess) {
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
                  title: 'account'.tr(),
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: chat,
                  title: 'chats'.tr(),
                  onPressed: () {},
                ),
                const Divider(color: Color(0xFFEDEDED)),
                MenuItem(
                  iconAsset: appearance,
                  title: 'appearance'.tr(),
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: notification,
                  title: 'notification'.tr(),
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: privacy,
                  title: 'privacy'.tr(),
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: dataUsage,
                  title: 'data_usage'.tr(),
                  onPressed: () {},
                ),
                const Divider(color: Color(0xFFEDEDED)),
                MenuItem(
                  iconAsset: help,
                  title: 'help'.tr(),
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: inviteFriends,
                  title: 'invite_friends'.tr(),
                  onPressed: () {},
                ),
                MenuItem(
                  iconAsset: account,
                  title: 'sign_out'.tr(),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const SignOutUserEvent(),
                        );
                  },
                ),
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12, right: 0),
                      child: SwitchListTile(
                        title: Text(
                          'dark_mode'.tr(),
                        ),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      final locale = context.read<LocaleBloc>().state
                                  is LocaleLoaded &&
                              (context.read<LocaleBloc>().state as LocaleLoaded)
                                      .locale
                                      .languageCode ==
                                  'en'
                          ? const Locale('ur')
                          : const Locale('en');
                      context.read<LocaleBloc>().add(ChangeLocaleEvent(locale));
                      context.setLocale(locale);
                    },
                    child: Text(
                      'change_language'.tr(),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is AuthError) {
            return Center(
              child: Text(
                'error'.tr() + state.message,
              ),
            );
          } else {
            return Center(
              child: Text(
                'unexpected_state'.tr(),
              ),
            );
          }
        },
      ),
    );
  }
}
