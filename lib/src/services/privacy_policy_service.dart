import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPolicyService {
  static const String _privacyAcceptedKey = 'privacy_policy_accepted';

  // Check if the user has accepted the privacy policy
  static Future<bool> hasAcceptedPrivacyPolicy() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_privacyAcceptedKey) ?? false;
  }

  // Mark the privacy policy as accepted
  static Future<void> setPrivacyPolicyAccepted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyAcceptedKey, true);
  }

  // Reset the privacy policy acceptance (for testing)
  static Future<void> resetPrivacyPolicyAcceptance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_privacyAcceptedKey);
  }
}
