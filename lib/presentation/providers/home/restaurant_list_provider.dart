import 'package:flutter/material.dart';
import 'package:restaurant_app/data/remote/service/api_service.dart';
import 'package:restaurant_app/utils/app_list_result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantListProvider(this._apiService);

  AppListResultState _resultState = AppListNoneState();

  AppListResultState get resultState => _resultState;

  Future<void> getRestaurantList() async {
    try {
      _resultState = AppListLoadingState();
      notifyListeners();

      final result = await _apiService.getListRestaurant();

      if (result.error) {
        _resultState = AppListErrorState(error: result.message);
        notifyListeners();
      } else {
        _resultState = AppListLoadedState(data: result);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = AppListErrorState(error: e.toString());
      notifyListeners();
    }
  }
}
