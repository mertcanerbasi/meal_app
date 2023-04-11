import 'package:meal_app/core/data/models/meal_model/meal_model.dart';

abstract class FavoritesStates {}

class FavoritesInitialState extends FavoritesStates {}

class FavoritesLoadingState extends FavoritesStates {}

class FavoritesSuccessState extends FavoritesStates {
  final List<MealModel> favoriteMealsList;

  FavoritesSuccessState({required this.favoriteMealsList});
}

class FavoritesErrorState extends FavoritesStates {
  final String error;

  FavoritesErrorState({required this.error});
}
