import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:property_manage/src/providers/auth_provider.dart';
import 'package:property_manage/src/services/session_management_service.dart';

class ApiService {
  final AuthProvider authProvider;
  final String _apiBaseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://admin.hyfb6.com/api';
  final SessionService _sessionService = SessionService();

  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  ApiService(this.authProvider);

  Future<void> _handleAuthenticationError() async {
    if (_context != null && _context!.mounted) {
      GoRouter.of(_context!).go('/onboarding');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    if (!authProvider.isAuthenticated) {
      _handleAuthenticationError();
      return {};
    }

    try {
      final url = Uri.parse('$_apiBaseUrl/$endpoint');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          return {'success': true};
        }
      } else if (response.statusCode == 401) {
        await _sessionService.handleSessionExpiry(authProvider);
        _handleAuthenticationError();
        return {};
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          final errorMessage =
              errorResponse['message'] ??
              errorResponse['error'] ??
              'Unknown error';
          return {'error': errorMessage};
        } catch (e) {
          return {'error': 'API Error: ${response.statusCode}'};
        }
      }
    } catch (e) {
      return {'error': 'Network error'};
    }
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String?>? queryParams,
  }) async {
    if (!authProvider.isAuthenticated) {
      _handleAuthenticationError();
      return {'results': []};
    }

    try {
      final url = Uri.parse(
        '$_apiBaseUrl/$endpoint',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        await _sessionService.handleSessionExpiry(authProvider);
        _handleAuthenticationError();
        return {'results': []};
      } else {
        return {'results': []};
      }
    } catch (e) {
      return {'results': []};
    }
  }

  Future<List<dynamic>> getPosts() async {
    try {
      final data = await get('posts');
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        return data['results'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getWithFullUrl(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        _handleAuthenticationError();
        return {'results': []};
      } else {
        return {'results': []};
      }
    } catch (e) {
      return {'results': []};
    }
  }
}
