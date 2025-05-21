import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  String? _error;
  bool _initialized = false;

  final String _apiBaseUrl =
      dotenv.env['API_BASE_URL'] ?? 'https://admin.hyfb6.com/api';

  bool get isAuthenticated =>
      _token != null && _token!.isNotEmpty && _initialized;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  bool get initialized => _initialized;

  AuthProvider() {
    _loadTokenFromStorage();
  }

  Future<void> _loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('auth_token');

    if (storedToken != null && storedToken.isNotEmpty) {
      _token = storedToken;
    }

    _initialized = true;
    notifyListeners();
  }

  Future<void> ensureInitialized() async {
    if (!_initialized) {
      final completer = Completer<void>();
      void listener() {
        if (_initialized) {
          completer.complete();
          removeListener(listener);
        }
      }

      addListener(listener);

      return completer.future;
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$_apiBaseUrl/token/'));
      request.body = json.encode({
        "username": "soegyi",
        "password": "ss123123",
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        _token = data['access'] ?? data['refresh'];

        if (_token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', _token!);

          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _error = 'Authentication failed. Please check your credentials.';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Network error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    notifyListeners();
  }
}
