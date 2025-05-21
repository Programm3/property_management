import 'package:flutter/foundation.dart';
import 'package:property_manage/src/services/api_service.dart';
import 'package:http/http.dart' as http;

class MessageProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _successMessage;
  final ApiService _apiService;

  MessageProvider(this._apiService);

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<bool> sendMessage({
    required String name,
    required String content,
    required String contact,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      String ip = await _getUserIP();
      final bool isEmail = contact.contains('@');

      final Map<String, dynamic> body = {
        'name': name,
        'content': content,
        'ip': ip,
      };

      if (isEmail) {
        body['email'] = contact;
      } else {
        body['contact'] = contact;
      }

      await _apiService.post('message/', body);

      _isLoading = false;
      _successMessage = 'Message sent successfully';
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      print('Failed to send message: $_error');

      return false;
    }
  }

  Future<String> _getUserIP() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org'));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print('Error getting IP: $e');
    }
    return '127.0.0.1';
  }

  void resetState() {
    _isLoading = false;
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
