import 'package:flutter/material.dart';
import 'package:restaurant_app/data/service/api_service.dart';
import 'package:restaurant_app/utils/app_detail_result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantDetailProvider(this._apiService);

  AppDetailResultState _resultState = AppDetailNoneState();

  AppDetailResultState get resultState => _resultState;

  Future<void> getDetailRestaurant(String id) async {
    try {
      _resultState = AppDetailLoadingState();
      notifyListeners();

      final response = await _apiService.getDetailRestaurant(id);

      if (response.error) {
        _resultState = AppDetailErrorState(error: response.message);
        notifyListeners();
      } else {
        _resultState = AppDetailLoadedState(data: response.restaurant);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = AppDetailErrorState(error: e.toString());
      notifyListeners();
    }
  }
}
