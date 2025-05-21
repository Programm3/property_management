import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('zh', 'CN');

  Locale get currentLocale => _currentLocale;

  final Map<String, Locale> supportedLanguages = {
    '中文': const Locale('zh', 'CN'),
    'English': const Locale('en', 'US'),
    'ไทย': const Locale('th', 'TH'),
    'မြန်မာ': const Locale('yma', 'MM'),
  };

  LanguageProvider() {
    loadSavedLanguage();
  }

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('languageCode');
    final savedCountry = prefs.getString('countryCode');

    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage, savedCountry);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageName) async {
    if (!supportedLanguages.containsKey(languageName)) return;

    _currentLocale = supportedLanguages[languageName]!;
    notifyListeners();

    // Save the preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', _currentLocale.languageCode);
    await prefs.setString('countryCode', _currentLocale.countryCode ?? '');
  }

  //  current language name
  String getCurrentLanguageName() {
    for (final entry in supportedLanguages.entries) {
      if (entry.value.languageCode == _currentLocale.languageCode) {
        return entry.key;
      }
    }
    return '中文';
  }
}
