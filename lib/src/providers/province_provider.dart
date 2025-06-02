import 'package:flutter/foundation.dart';
import 'package:property_manage/src/models/province.dart';
import 'package:property_manage/src/services/api_service.dart';

class ProvinceProvider with ChangeNotifier {
  List<Province> _provinces = [
    Province(
      id: null,
      name: 'all',
      nameChinese: 'all',
      nameThailand: 'all',
      nameMyanmar: 'all',
    ),
  ];
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService;

  ProvinceProvider(this._apiService);

  List<Province> get provinces => _provinces;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProvinces() async {
    if (_provinces.length > 1) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('province');

      if (response is List) {
        final apiProvinces =
            response.map((item) => Province.fromJson(item)).toList();
        _provinces = [_provinces[0], ...apiProvinces];
      } else if (response is Map) {
        if (response.containsKey('results')) {
          final results = response['results'];
          if (results is List) {
            final apiProvinces =
                results.map((item) => Province.fromJson(item)).toList();
            _provinces = [_provinces[0], ...apiProvinces];
          }
        } else {
          for (var key in response.keys) {
            if (response[key] is List) {
              final apiProvinces =
                  (response[key] as List)
                      .map((item) => Province.fromJson(item))
                      .toList();
              _provinces = [_provinces[0], ...apiProvinces];
              break;
            }
          }
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      // print('Failed to load provinces: $_error');
    }
  }
}
