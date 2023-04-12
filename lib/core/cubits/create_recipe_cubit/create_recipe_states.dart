abstract class CreateRecipeStates {}

class CreateRecipeInitialState extends CreateRecipeStates {}

class CreateRecipeLoadingState extends CreateRecipeStates {}

class CreateRecipeSuccessState extends CreateRecipeStates {}

class CreateRecipeErrorState extends CreateRecipeStates {
  final String error;
  CreateRecipeErrorState({required this.error});
}
