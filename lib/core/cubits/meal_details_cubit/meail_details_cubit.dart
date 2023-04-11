import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/meal_details_cubit/meail_details_states.dart';

class MealDetailsCubit extends Cubit<MealDetailsStates> {
  MealDetailsCubit() : super(MealDetailsInitialState());

  static MealDetailsCubit get(context) => BlocProvider.of(context);

  List<String> favoriteMealsList = [];

  String? mealId;

  bool isFavorite = false;

  void getFavoriteMealsListFromFirebase({required String id}) async {
    emit(MealDetailsLoadingState());
    mealId = id;
    favoriteMealsList.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      for (var element in value.data()?['favoriteMealsList']) {
        favoriteMealsList.add(element);
      }
      if (favoriteMealsList.contains(id)) {
        isFavorite = true;
      } else {
        isFavorite = false;
      }
      emit(MealDetailsSuccessState());
    }).catchError((onError) {
      emit(MealDetailsErrorState(error: onError.toString()));
    });
  }

  void handleFavorite() async {
    if (isFavorite) {
      favoriteMealsList.remove(mealId);
      isFavorite = false;
    } else {
      favoriteMealsList.add(mealId!);
      isFavorite = true;
    }
    await FirebaseFirestore.instance
        .collection('favoriteMeals')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'mealsList': favoriteMealsList}).then((value) {
      addMealToFavoriteList(id: mealId!);
    }).catchError((onError) {
      emit(MealDetailsErrorState(error: onError.toString()));
    });
  }

  void addMealToFavoriteList({required String id}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'favoriteMealsList': favoriteMealsList}).then((value) {
      emit(MealDetailsSuccessState());
    }).catchError((onError) {
      emit(MealDetailsErrorState(error: onError.toString()));
    });
  }
}
