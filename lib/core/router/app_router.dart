import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/features/auth/presentation/pages/landing_page.dart';
import 'package:chat_app/features/auth/presentation/pages/phone_number_page.dart';
import 'package:chat_app/features/auth/presentation/pages/profile_setup_page.dart';
import 'package:chat_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:chat_app/features/auth/presentation/pages/sign_in_verfication_page.dart';
import 'package:chat_app/features/auth/presentation/pages/verification_page.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_homepage.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/chat/presentation/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter()
      : router = GoRouter(
          initialLocation: routeMap[AppRoute.landing],
          debugLogDiagnostics: true,
          routes: [
            GoRoute(
              path: routeMap[AppRoute.landing]!,
              name: AppRoute.landing.name,
              builder: (context, state) => const LandingPage(),
              routes: [
                GoRoute(
                  path: routeMap[AppRoute.phone]!,
                  name: AppRoute.phone.name,
                  builder: (context, state) => PhoneNumberPage(),
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
                          builder: (context, state) => ProfileSetupPage(),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: routeMap[AppRoute.signin]!,
                  name: AppRoute.signin.name,
                  builder: (context, state) => SignInPage(),
                  routes: [
                    GoRoute(
                      path: routeMap[AppRoute.signin_verification]!,
                      name: AppRoute.signin_verification.name,
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
            ShellRoute(
              navigatorKey: _rootNavigatorKey,
              builder: (context, state, child) =>
                  CustomBottomNavBar(child: child),
              routes: [
                GoRoute(
                  path: routeMap[AppRoute.chatHome]!,
                  name: AppRoute.chatHome.name,
                  pageBuilder: (context, state) =>
                      NoTransitionPage(child: ChatHomePage()),
                ),
                GoRoute(
                  path: routeMap[AppRoute.chat]!,
                  name: AppRoute.chat.name,
                  pageBuilder: (context, state) {
                    final chatId = state.pathParameters['chatId']!;
                    return NoTransitionPage(child: ChatPage(chatId: chatId));
                  },
                ),
              ],
            ),
          ],
        );

  final GoRouter router;
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
