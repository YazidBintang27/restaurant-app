import 'package:restaurant_app/data/models/response/restaurant_list.dart';
import 'package:restaurant_app/data/models/response/restaurant_search.dart';

sealed class AppSearchResultState {}

class AppSearchNoneState extends AppSearchResultState {}

class AppSearchLoadingState extends AppSearchResultState {}

class AppSearchErrorState extends AppSearchResultState {
  final String error;

  AppSearchErrorState({required this.error});
}

class AppSearchLoadedState extends AppSearchResultState {
  final RestaurantSearch data;

  AppSearchLoadedState({required this.data});
}
