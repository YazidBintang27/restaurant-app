import 'package:flutter/material.dart';
import 'package:restaurant_app/data/remote/service/api_service.dart';
import 'package:restaurant_app/utils/app_search_result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantSearchProvider(this._apiService);

  AppSearchResultState _resultState = AppSearchNoneState();

  AppSearchResultState get resultState => _resultState;

  Future<void> searchRestaurant(String query) async {
    try {
      _resultState = AppSearchLoadingState();
      notifyListeners();

      final result = await _apiService.searchRestaurant(query);

      if (result.error) {
        _resultState = AppSearchErrorState(error: 'Something went wrong!');
        notifyListeners();
      } else {
        _resultState = AppSearchLoadedState(data: result);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = AppSearchErrorState(error: e.toString());
      notifyListeners();
    }
  }
}
