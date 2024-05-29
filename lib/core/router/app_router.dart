import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/features/auth/presentation/pages/profile_setup_page.dart';
import 'package:chat_app/features/auth/presentation/pages/landing_page.dart';
import 'package:chat_app/features/auth/presentation/pages/phone_number_page.dart';
import 'package:chat_app/features/auth/presentation/pages/verification_page.dart';
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
                      builder: (context, state) => const VerificationPage(),
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
              ],
            ),
          ],
        );
  final GoRouter router;
}
