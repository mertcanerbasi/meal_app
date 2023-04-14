import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/search_cubit/search_states.dart';
import 'package:meal_app/core/data/models/meal_model/meal_model.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  List<MealModel> mealsList = [];
  List<MealModel> searchedMealsList = [];

  int perPage = 10;
  int pageNumber = 1;
  int get totalPage => (mealsList.length / perPage).ceil();
  int get totalPageForSearched => (searchedMealsList.length / perPage).ceil();

  bool isIncreasable() => totalPage > pageNumber;
  bool isDecreasable() => pageNumber > 1;

  bool isIncreasableSearched() => totalPageForSearched > pageNumber;

  void increasePageNumber() {
    if (isIncreasable()) {
      pageNumber++;
      emit(SearchSuccess(searchResults: currentMealsList));
    }
  }

  void decreasePageNumber() {
    if (isDecreasable()) {
      pageNumber--;
      emit(SearchSuccess(searchResults: currentMealsList));
    }
  }

  void increasePageNumberSearched() {
    if (isIncreasableSearched()) {
      pageNumber++;
      emit(SearchedState(searchResults: searchedMealsList));
    }
  }

  void decreasePageNumberSearched() {
    if (isDecreasable()) {
      pageNumber--;
      emit(SearchedState(searchResults: searchedMealsList));
    }
  }

  List<MealModel> get currentMealsList =>
      mealsList.skip((pageNumber - 1) * perPage).take(perPage).toList();

  void getMealsList() async {
    emit(SearchLoading());
    mealsList.clear();
    await FirebaseFirestore.instance
        .collection('meals')
        .orderBy("likes", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        mealsList.add(MealModel.fromJson(element.data()));
      }
      emit(SearchSuccess(searchResults: mealsList));
    }).catchError((onError) {
      emit(SearchError(onError.toString()));
    });
  }

  void getMealsWithContainsName(String name) {
    searchedMealsList.clear();
    for (var element in mealsList) {
      if (element.name.toLowerCase().contains(name.toLowerCase())) {
        searchedMealsList.add(element);
      }
      emit(SearchedState(searchResults: searchedMealsList));
    }
  }
}
