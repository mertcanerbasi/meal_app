import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/create_recipe_cubit/create_recipe_states.dart';
import 'package:meal_app/core/data/models/meal_model/meal_model.dart';
import 'package:meal_app/core/data/models/meal_type_model/meal_type_model.dart';
import 'package:uuid/uuid.dart';

class CreateRecipeCubit extends Cubit<CreateRecipeStates> {
  CreateRecipeCubit() : super(CreateRecipeInitialState());

  static CreateRecipeCubit get(context) => BlocProvider.of(context);

  void createRecipe({required String mealName}) async {
    emit(CreateRecipeLoadingState());
    String id = const Uuid().v4();
    MealModel mealModel = MealModel(
        name: mealName,
        chefUid: FirebaseAuth.instance.currentUser!.uid,
        likes: 0,
        minutes: 35,
        mealTypes: mealType.name,
        mealId: id,
        ingredients: ingredientsList,
        tags: tags,
        image:
            "https://australianmushrooms.com.au/wp-content/uploads/2019/06/Herb-and-Garlic-Mushrooms-with-minute-steak03-2000x2000.jpg");
    await FirebaseFirestore.instance
        .collection('meals')
        .doc(id)
        .set(mealModel.toJson())
        .then((value) {
      ingredientsList.clear();
      tags.clear();
      emit(CreateRecipeSuccessState());
    }).catchError((error) {
      emit(CreateRecipeErrorState(error: error.toString()));
    });
  }

  void clearState() {
    ingredientsList.clear();
    tags.clear();
    emit(CreateRecipeInitialState());
  }

  MealType mealType = MealType.breakfast;
  void changeMealType(String? value) {
    if (value == MealType.breakfast.name) {
      mealType = MealType.breakfast;
    } else if (value == MealType.lunch.name) {
      mealType = MealType.lunch;
    } else if (value == MealType.dinner.name) {
      mealType = MealType.dinner;
    } else if (value == MealType.snacks.name) {
      mealType = MealType.snacks;
    }

    emit(CreateRecipeInitialState());
  }

  List<String> mealTypes = [
    MealType.breakfast.name,
    MealType.lunch.name,
    MealType.dinner.name,
    MealType.snacks.name
  ];

  List<String> ingredientsList = [];

  void addIndgredient(String ingredient) {
    ingredientsList.add(ingredient);
    emit(CreateRecipeInitialState());
  }

  void removeIngredient(int index) {
    ingredientsList.removeAt(index);
    emit(CreateRecipeInitialState());
  }

  List<String> tags = [];

  void addTag(String tag) {
    tags.add(tag);
    emit(CreateRecipeInitialState());
  }

  void removeTag(int index) {
    tags.removeAt(index);
    emit(CreateRecipeInitialState());
  }
}
