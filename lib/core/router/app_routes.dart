enum AppRoute {
  landing,
  phone,
  verify,
  profileSetup,
  signin,
  signinVerification,
  chatHome,
  chat,
  contacts,
  more,
}

const Map<AppRoute, String> routeMap = {
  AppRoute.landing: '/',
  AppRoute.phone: 'phone',
  AppRoute.verify: 'verify',
  AppRoute.profileSetup: 'profileSetup',
  AppRoute.signin: 'signin',
  AppRoute.signinVerification: 'signin_verification',
  AppRoute.chatHome: '/chatHome',
  AppRoute.chat: 'chat',
  AppRoute.contacts: '/contact',
  AppRoute.more: '/more',
};
