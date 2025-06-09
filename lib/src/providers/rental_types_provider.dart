import 'package:flutter/foundation.dart';
import 'package:property_manage/src/models/rent_type.dart';
import 'package:property_manage/src/services/api_service.dart';

class RentalTypesProvider with ChangeNotifier {
  List<RentType> _rentTypes = [];
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService;

  RentalTypesProvider(this._apiService);

  List<RentType> get rentTypes => _rentTypes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRentTypes() async {
    if (_rentTypes.isNotEmpty && _error == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('rent-type');

      _rentTypes = [];

      if (response is List) {
        _rentTypes = response.map((item) => RentType.fromJson(item)).toList();
      } else if (response is Map) {
        if (response.containsKey('results')) {
          final results = response['results'];
          if (results is List) {
            _rentTypes =
                results.map((item) => RentType.fromJson(item)).toList();
          }
        } else {
          for (var key in response.keys) {
            if (response[key] is List) {
              _rentTypes =
                  (response[key] as List)
                      .map((item) => RentType.fromJson(item))
                      .toList();
              break;
            }
          }
        }
      }

      if (_rentTypes.isEmpty) {
        _error = "No rental types found in the response";
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      // print('Failed to load rent types: $_error');
    }
  }

  RentType? getRentTypeById(String id) {
    try {
      return _rentTypes.firstWhere((rentType) => rentType.id.toString() == id);
    } catch (e) {
      return null;
    }
  }
}
