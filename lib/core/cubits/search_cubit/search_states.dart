import 'package:meal_app/core/data/models/meal_model/meal_model.dart';

abstract class SearchStates {}

class SearchInitial extends SearchStates {}

class SearchLoading extends SearchStates {}

class SearchSuccess extends SearchStates {
  final List<MealModel> searchResults;

  SearchSuccess({required this.searchResults});
}

class SearchedState extends SearchStates {
  final List<MealModel> searchResults;

  SearchedState({required this.searchResults});
}

class SearchError extends SearchStates {
  final String error;

  SearchError(this.error);
}
