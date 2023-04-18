import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/home_cubit/home_states.dart';
import 'package:meal_app/core/data/models/meal_model/meal_model.dart';
import 'package:meal_app/core/data/models/meal_type_model/meal_type_model.dart';
import 'package:meal_app/core/data/services/google_ads.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);
  List<MealTypeModel> mealTypesList = [
    MealTypeModel(label: MealType.breakfast.name, isSelected: true),
    MealTypeModel(label: MealType.lunch.name, isSelected: false),
    MealTypeModel(label: MealType.snacks.name, isSelected: false),
    MealTypeModel(label: MealType.dinner.name, isSelected: false),
  ];

  GoogleAds googleAds = GoogleAds();

  List<MealModel> mealsList = [];
  MealType currentMealType = MealType.breakfast;

  List<MealModel> get currentMealsList => mealsList
      .where((element) => element.mealTypes == currentMealType.name)
      .toList();

  void changeMealType(int index) {
    for (int i = 0; i < mealTypesList.length; i++) {
      if (i == index) {
        mealTypesList[i].isSelected = true;
        currentMealType = mealTypesList[i].label == MealType.lunch.name
            ? MealType.lunch
            : mealTypesList[i].label == MealType.dinner.name
                ? MealType.dinner
                : mealTypesList[i].label == MealType.breakfast.name
                    ? MealType.breakfast
                    : MealType.snacks;
      } else {
        mealTypesList[i].isSelected = false;
      }
    }
    emit(HomeSuccessState(mealsList: mealsList));
  }

  void getMealsList() async {
    emit(HomeLoadingState());
    mealsList.clear();
    await FirebaseFirestore.instance
        .collection('meals')
        .orderBy("likes", descending: true)
        .limit(100)
        .get()
        .then((value) {
      for (var element in value.docs) {
        mealsList.add(MealModel.fromJson(element.data()));
      }
      emit(HomeSuccessState(mealsList: mealsList));
    }).catchError((onError) {
      emit(HomeErrorState(onError.toString()));
    });
  }
}
