import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/features/auth/presentation/pages/landing_page.dart';
import 'package:chat_app/features/auth/presentation/pages/phone_number_page.dart';
import 'package:chat_app/features/auth/presentation/pages/profile_setup_page.dart';
import 'package:chat_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:chat_app/features/auth/presentation/pages/sign_in_verfication_page.dart';
import 'package:chat_app/features/auth/presentation/pages/verification_page.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_home_page.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/chat/presentation/pages/more_page.dart';
import 'package:chat_app/features/chat/presentation/widgets/bottom_navigation.dart';
import 'package:chat_app/features/contact/presentation/pages/contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter()
      : router = GoRouter(
          initialLocation: routeMap[AppRoute.landing],
          debugLogDiagnostics: true,
          navigatorKey: _rootNavigatorKey,
          routes: [
            GoRoute(
              path: routeMap[AppRoute.landing]!,
              name: AppRoute.landing.name,
              builder: (context, state) => const LandingPage(),
              routes: [
                GoRoute(
                  path: routeMap[AppRoute.phone]!,
                  name: AppRoute.phone.name,
                  builder: (context, state) => const PhoneNumberPage(),
                  routes: [
                    GoRoute(
                      path: routeMap[AppRoute.verify]!,
                      name: AppRoute.verify.name,
                      builder: (context, state) {
                        final verificationId = state.extra! as String;
                        return VerificationPage(verificationId: verificationId);
                      },
                      routes: [
                        GoRoute(
                          path: routeMap[AppRoute.profileSetup]!,
                          name: AppRoute.profileSetup.name,
                          builder: (context, state) => const ProfileSetupPage(),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: routeMap[AppRoute.signin]!,
                  name: AppRoute.signin.name,
                  builder: (context, state) => const SignInPage(),
                  routes: [
                    GoRoute(
                      path: routeMap[AppRoute.signinVerification]!,
                      name: AppRoute.signinVerification.name,
                      builder: (context, state) {
                        final verificationId = state.extra! as String;
                        return SignInVerificationPage(
                          verificationId: verificationId,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellRoute.indexedStack(
              branches: <StatefulShellBranch>[
                StatefulShellBranch(
                  navigatorKey: _chatHomeRootNavigatorKey,
                  initialLocation: routeMap[AppRoute.chatHome],
                  routes: [
                    GoRoute(
                      path: routeMap[AppRoute.chatHome]!,
                      name: AppRoute.chatHome.name,
                      builder: (context, state) => const ChatHomePage(),
                      routes: [
                        GoRoute(
                          parentNavigatorKey: _rootNavigatorKey,
                          path: routeMap[AppRoute.chat]!,
                          name: AppRoute.chat.name,
                          builder: (context, state) {
                            final contactId =
                                state.uri.queryParameters['chatId']!;
                            final receiverId =
                                state.uri.queryParameters['receiverId']!;

                            final phoneNumber = state.uri.queryParameters['phoneNumber']!;
                            return ChatPage(
                              chatId: contactId,
                              phoneNumber: phoneNumber,
                              receiverId: receiverId,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                StatefulShellBranch(
                  navigatorKey: _contactsRootNavigatorKey,
                  initialLocation: routeMap[AppRoute.contacts],
                  routes: [
                    GoRoute(
                      path: routeMap[AppRoute.contacts]!,
                      name: AppRoute.contacts.name,
                      builder: (context, state) => const ContactsPage(),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  navigatorKey: _moreRootNavigatorKey,
                  initialLocation: routeMap[AppRoute.more],
                  routes: [
                    GoRoute(
                      path: routeMap[AppRoute.more]!,
                      name: AppRoute.more.name,
                      builder: (context, state) => const MorePage(),
                      routes:[
                        GoRoute(
                          path: routeMap[AppRoute.landing]!,
                          name: AppRoute.landing.name,
                          builder: (context, state) => const LandingPage(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              builder: (
                context,
                GoRouterState state,
                StatefulNavigationShell shell,
              ) {
                return CustomBottomNavBar(
                  shell: shell,
                );
              },
            ),
          ],
        );

  final GoRouter router;
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _chatHomeRootNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _contactsRootNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _moreRootNavigatorKey =
    GlobalKey<NavigatorState>();
