import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LanguageProvider extends ChangeNotifier {
  late Locale _currentLocale;
  Locale get currentLocale => _currentLocale;

  final Map<String, Locale> supportedLanguages = {
    '中文': const Locale('zh', 'CN'),
    'English': const Locale('en', 'US'),
    'ไทย': const Locale('th', 'TH'),
    'မြန်မာ': const Locale('my', 'MM'),
  };

  String _getLanguageNameFromLocale(Locale locale) {
    for (final entry in supportedLanguages.entries) {
      if (entry.value.languageCode == locale.languageCode) {
        return entry.key;
      }
    }
    return '中文';
  }

  LanguageProvider() {
    _currentLocale = const Locale('zh', 'CN');
    loadSavedLanguage();
  }

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('languageCode');
    final savedCountry = prefs.getString('countryCode');

    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage, savedCountry);
    } else {
      final deviceLocale = ui.PlatformDispatcher.instance.locale;
      print('Device locale: $deviceLocale');
      final deviceLanguageCode = deviceLocale.languageCode;
      print('Device language code: $deviceLanguageCode');
      bool languageSupported = false;
      for (final locale in supportedLanguages.values) {
        if (locale.languageCode == deviceLanguageCode) {
          _currentLocale = locale;
          languageSupported = true;

          await prefs.setString('languageCode', _currentLocale.languageCode);
          await prefs.setString(
            'countryCode',
            _currentLocale.countryCode ?? '',
          );
          break;
        }
      }

      if (!languageSupported) {
        _currentLocale = const Locale('zh', 'CN');
        await prefs.setString('languageCode', 'zh');
        await prefs.setString('countryCode', 'CN');
      }
    }
    notifyListeners();
  }

  Future<void> changeLanguage(String languageName) async {
    if (!supportedLanguages.containsKey(languageName)) return;

    _currentLocale = supportedLanguages[languageName]!;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', _currentLocale.languageCode);
    await prefs.setString('countryCode', _currentLocale.countryCode ?? '');
  }

  //  current language name
  String getCurrentLanguageName() {
    return _getLanguageNameFromLocale(_currentLocale);
  }

  Future<void> useSystemLanguage() async {
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final deviceLanguageCode = deviceLocale.languageCode;

    bool found = false;
    for (final entry in supportedLanguages.entries) {
      if (entry.value.languageCode == deviceLanguageCode) {
        await changeLanguage(entry.key);
        found = true;
        break;
      }
    }

    if (!found) {
      await changeLanguage('中文');
    }
  }
}
