abstract class MealDetailsStates {}

class MealDetailsInitialState extends MealDetailsStates {}

class MealDetailsLoadingState extends MealDetailsStates {}

class MealDetailsSuccessState extends MealDetailsStates {}

class MealDetailsErrorState extends MealDetailsStates {
  final String error;

  MealDetailsErrorState({required this.error});
}
