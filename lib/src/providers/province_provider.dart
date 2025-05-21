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

      final apiProvinces =
          (response as List).map((item) => Province.fromJson(item)).toList();

      _provinces = [_provinces[0], ...apiProvinces];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Failed to load provinces: $_error');
    }
  }
}
