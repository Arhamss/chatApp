enum AppRoute {
  landing,
  phone,
  verify,
  profileSetup,
  signin,
  signin_verification,
  chatHome,
  chat,
}

const Map<AppRoute, String> routeMap = {
  AppRoute.landing: '/',
  AppRoute.phone: 'phone',
  AppRoute.verify: 'verify',
  AppRoute.profileSetup: 'profileSetup',
  AppRoute.signin: 'signin',
  AppRoute.signin_verification: 'signin_verification',
  AppRoute.chatHome: '/chatHome',
  AppRoute.chat: '/chat/:chatId',
};
