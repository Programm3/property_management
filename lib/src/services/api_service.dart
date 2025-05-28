import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:property_manage/src/providers/auth_provider.dart';
import 'package:property_manage/src/services/session_management_service.dart';

class ApiService {
  final AuthProvider authProvider;
  final String _apiBaseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://admin.hyfb6.com/api';
  final SessionService _sessionService = SessionService();

  ApiService(this.authProvider);
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    if (!authProvider.isAuthenticated) {
      throw Exception('Not authenticated');
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
        throw Exception('Session expired');
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          final errorMessage =
              errorResponse['message'] ??
              errorResponse['error'] ??
              'Unknown error';
          throw Exception('API Error: $errorMessage');
        } catch (e) {
          throw Exception('API Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String?>? queryParams,
  }) async {
    if (!authProvider.isAuthenticated) {
      throw Exception('Not authenticated');
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
        throw Exception('Session expired');
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<dynamic>> getPosts() async {
    try {
      final data = await get('posts');
      return data as List<dynamic>;
    } catch (e) {
      rethrow;
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
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
