import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:property_manage/src/routes.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;

    if (location.startsWith(AppRoutes.contact)) {
      currentIndex = 1;
    } else if (location.startsWith(AppRoutes.cooperation)) {
      currentIndex = 2;
    } else if (location.startsWith(AppRoutes.config)) {
      currentIndex = 3;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF26CB93),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.contact);
              break;
            case 2:
              context.go(AppRoutes.cooperation);
              break;
            case 3:
              context.go(AppRoutes.config);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/property_tab_inactive.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/property_tab_active.png',
              width: 24,
              height: 24,
            ),
            label:
                AppLocalizations.of(
                  context,
                ).translate('propertiesTab').toUpperCase(),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/contact_tab_inactive.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/contact_tab_active.png',
              width: 24,
              height: 24,
            ),
            label:
                AppLocalizations.of(
                  context,
                ).translate('contactUs').toUpperCase(),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/cooperation_tab_inactive.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/cooperation_tab_active.png',
              width: 24,
              height: 24,
            ),
            label:
                AppLocalizations.of(
                  context,
                ).translate('cooperation').toUpperCase(),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/config_tab_inactive.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/config_tab_active.png',
              width: 24,
              height: 24,
            ),
            label:
                AppLocalizations.of(context).translate('config').toUpperCase(),
          ),
        ],
      ),
    );
  }
}
