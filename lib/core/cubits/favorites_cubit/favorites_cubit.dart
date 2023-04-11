import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/favorites_cubit/favorites_states.dart';
import 'package:meal_app/core/data/models/meal_model/meal_model.dart';

class FavoritesCubit extends Cubit<FavoritesStates> {
  FavoritesCubit() : super(FavoritesInitialState());

  static FavoritesCubit get(context) => BlocProvider.of(context);

  List<MealModel> favoriteMealsList = [];
  List<String> favoritesIdList = [];

  void getFavorites() async {
    emit(FavoritesLoadingState());
    favoritesIdList.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      for (var element in value.data()?['favoriteMealsList']) {
        favoritesIdList.add(element);
      }
      getMealDetails();
    }).catchError((onError) {
      emit(FavoritesErrorState(error: onError.toString()));
    });
  }

  void getMealDetails() {
    favoriteMealsList.clear();
    FirebaseFirestore.instance.collection('meals').get().then((value) {
      for (var element in value.docs) {
        if (favoritesIdList.contains(element.id)) {
          favoriteMealsList.add(MealModel.fromJson(element.data()));
        }
      }
      emit(FavoritesSuccessState(favoriteMealsList: favoriteMealsList));
    }).catchError((onError) {
      emit(FavoritesErrorState(error: onError.toString()));
    });
  }
}
