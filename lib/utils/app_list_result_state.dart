import 'package:restaurant_app/data/models/response/restaurant_list.dart';

sealed class AppListResultState {}

class AppListNoneState extends AppListResultState {}

class AppListLoadingState extends AppListResultState {}

class AppListErrorState extends AppListResultState {
  final String error;

  AppListErrorState({required this.error});
}

class AppListLoadedState extends AppListResultState {
  final RestaurantList data;

  AppListLoadedState({required this.data});
}
