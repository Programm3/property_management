// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:property_manage/src/routes.dart';
import 'package:property_manage/src/providers/auth_provider.dart';

class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  Future<void> handleSessionExpiry(AuthProvider authProvider) async {
    await authProvider.logout();
    _restartApp();
  }

  void _restartApp() {
    router.go('/onboarding');
  }
}
