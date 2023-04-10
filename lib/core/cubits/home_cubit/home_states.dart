import 'package:meal_app/core/data/models/meal_model/meal_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeSuccessState extends HomeStates {
  final List<MealModel> mealsList;

  HomeSuccessState({required this.mealsList});
}

class HomeErrorState extends HomeStates {
  final String error;

  HomeErrorState(this.error);
}
