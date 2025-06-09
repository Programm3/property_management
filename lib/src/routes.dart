import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:property_manage/src/providers/auth_provider.dart';
import 'package:property_manage/src/services/privacy_policy_service.dart';
import 'package:property_manage/src/views/cooperation_page.dart';
import 'package:property_manage/src/views/details_page.dart';
import 'package:property_manage/src/views/home_search_page.dart';
import 'package:property_manage/src/views/on_boarding_page.dart';
import 'package:property_manage/src/views/on_boarding_2page.dart';
import 'package:property_manage/src/views/home_page.dart';
import 'package:property_manage/src/views/contact_page.dart';
import 'package:property_manage/src/layouts/main_layout.dart';
import 'package:property_manage/src/views/config_page.dart';
import 'package:property_manage/src/views/privacy_policy_page.dart';
import 'package:property_manage/src/views/switch_language_page.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  redirect: (BuildContext context, GoRouterState state) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool isAuthenticated = authProvider.isAuthenticated;
    final bool hasAcceptedPrivacyPolicy =
        await PrivacyPolicyService.hasAcceptedPrivacyPolicy();

    final publicRoutes = [
      '/onboarding',
      '/onboarding2',
      '/privacy-policy',
      '/contact',
    ];

    if (publicRoutes.any((route) => state.matchedLocation.startsWith(route))) {
      return null;
    }

    if (!hasAcceptedPrivacyPolicy || !isAuthenticated) {
      return '/onboarding';
    }
    return null;
  },
  routes: <RouteBase>[
    GoRoute(path: '/', redirect: (_, __) => '/home'),
    GoRoute(
      path: '/contact',
      name: 'contact',
      builder: (context, state) => MainLayout(child: const ContactPage()),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnBoardingPage(),
    ),
    GoRoute(
      path: '/onboarding2',
      name: 'onboarding2',
      builder: (context, state) {
        final rentTypeId = state.uri.queryParameters['rent_type'];
        return OnBoarding2Page(rentTypeId: rentTypeId);
      },
    ),

    GoRoute(
      path: '/switch-language',
      name: 'switchLanguage',
      builder: (context, state) => const SwitchLanguagePage(),
    ),

    GoRoute(
      path: '/privacy-policy',
      name: 'privacyPolicy',
      builder: (context, state) => const PrivacyPolicyPage(),
    ),

    GoRoute(
      path: '/details/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return DetailsPage(id: id);
      },
    ),

    GoRoute(
      path: '/home_search',
      name: 'home_search',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return HomeSearchPage(
          selectedProvince: extra?['selectedProvince'] as String?,
          selectedPropertyType: extra?['selectedPropertyType'] as String?,
          selectedRentType: extra?['selectedRentType'] as String?,
          properties: extra?['properties'] as List<dynamic>?,
        );
      },
    ),

    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) {
            final provinceId = state.uri.queryParameters['province'];
            final rentTypeId = state.uri.queryParameters['rent_type'];

            return HomePage(provinceId: provinceId, rentTypeId: rentTypeId);
          },
        ),
        GoRoute(
          path: '/cooperation',
          name: 'cooperation',
          builder: (context, state) => const CooperationPage(),
        ),
        GoRoute(
          path: '/config',
          name: 'config',
          builder: (context, state) => const ConfigPage(),
        ),
      ],
    ),
  ],

  onException: (_, GoRouterState state, GoRouter router) {
    router.go('/onboarding');
  },
);

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String onboarding2 = '/onboarding2';
  static const String home = '/home';
  static const String details = '/details';
  static const String contact = '/contact';
  static const String cooperation = '/cooperation';
  static const String config = '/config';
  static const String switchLanguage = '/switch-language';
  static const String privacyPolicy = '/privacy-policy';

  static const String initialRoute = home;

  static void navigateToOnboarding2(BuildContext context) {
    context.go(onboarding2);
  }

  static void navigateToHome(BuildContext context) {
    context.go(home);
  }
}
