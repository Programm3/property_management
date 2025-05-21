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
    if (_rentTypes.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('rent-type');

      _rentTypes =
          (response as List).map((item) => RentType.fromJson(item)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Failed to load rent types: $_error');
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
