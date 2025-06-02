import 'package:flutter/foundation.dart';
import 'package:property_manage/src/models/property_type.dart';
import 'package:property_manage/src/services/api_service.dart';

class PropertyProvider with ChangeNotifier {
  List<PropertyType> _propertyTypes = [
    PropertyType(
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

  PropertyProvider(this._apiService);

  List<PropertyType> get propertyTypes => _propertyTypes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPropertyTypes() async {
    if (_propertyTypes.length > 1) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('property-type');

      if (response is List) {
        final apiPropertyTypes =
            response.map((item) => PropertyType.fromJson(item)).toList();
        _propertyTypes = [_propertyTypes[0], ...apiPropertyTypes];
      } else if (response is Map) {
        if (response.containsKey('results')) {
          final results = response['results'];
          if (results is List) {
            final apiPropertyTypes =
                results.map((item) => PropertyType.fromJson(item)).toList();
            _propertyTypes = [_propertyTypes[0], ...apiPropertyTypes];
          }
        } else {
          for (var key in response.keys) {
            if (response[key] is List) {
              final apiPropertyTypes =
                  (response[key] as List)
                      .map((item) => PropertyType.fromJson(item))
                      .toList();
              _propertyTypes = [_propertyTypes[0], ...apiPropertyTypes];
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
      // print('Failed to load property types: $_error');
    }
  }

  PropertyType? getPropertyTypeById(String id) {
    try {
      return _propertyTypes.firstWhere(
        (property) => property.id.toString() == id,
      );
    } catch (e) {
      return null;
    }
  }
}
