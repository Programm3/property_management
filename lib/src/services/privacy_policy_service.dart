import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPolicyService {
  static const String _privacyAcceptedKey = 'privacy_policy_accepted';

  static Future<bool> hasAcceptedPrivacyPolicy() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_privacyAcceptedKey) ?? false;
  }

  static Future<void> setPrivacyPolicyAccepted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyAcceptedKey, true);
  }
}
