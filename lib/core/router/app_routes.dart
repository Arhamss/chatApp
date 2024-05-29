enum AppRoute {
  landing,
  phone,
  verify,
  profileSetup,
}

const Map<AppRoute, String> routeMap = {
  AppRoute.landing: '/',
  AppRoute.phone: 'phone',
  AppRoute.verify: 'verify',
  AppRoute.profileSetup: 'profileSetup',
};
