import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:property_manage/src/routes.dart';
import 'package:property_manage/src/providers/auth_provider.dart';

class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  Future<void> handleSessionExpiry(AuthProvider authProvider) async {
    await authProvider.logout();
    try {
      if (rootNavigatorKey.currentContext != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: rootNavigatorKey.currentContext!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Session Expired'),
                content: const Text(
                  'Your session has expired. Please login again.',
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _restartApp();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        });
      } else {
        Fluttertoast.showToast(
          msg: "Session expired. Will Restart the app.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        await Future.delayed(const Duration(seconds: 2));
        _restartApp();
      }
    } catch (e) {
      print("Error showing session expiry dialog: $e");
      _restartApp();
    }
  }

  void _restartApp() {
    router.go('/onboarding');
  }
}
