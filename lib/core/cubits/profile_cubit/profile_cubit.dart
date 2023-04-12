import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/profile_cubit/profile_states.dart';
import 'package:meal_app/core/data/models/meal_model/meal_model.dart';
import 'package:meal_app/core/data/models/user_model/user_model.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  UserModel? currentUser;

  int? get numberOfFavoriteFoods => currentUser?.favoriteMealsList.length;

  List<MealModel> numberOfUsersMeals = [];

  int? get numberOfUsersMealsLength => numberOfUsersMeals.length;

  void getCurrentUser({required String uId}) async {
    emit(ProfileLoadingState());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      currentUser = UserModel.fromJson(value.data()!);
      emit(ProfileSuccessState(currentUser: currentUser!));
    }).catchError((onError) {
      emit(ProfileErrorState(onError.toString()));
    });
  }

  void getAllMealsWithCurrentUserId() async {
    emit(ProfileLoadingState());
    numberOfUsersMeals.clear();
    await FirebaseFirestore.instance
        .collection('meals')
        .where('chefUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        numberOfUsersMeals.add(MealModel.fromJson(element.data()));
      }
      emit(ProfileSuccessState(currentUser: currentUser!));
    }).catchError((onError) {
      emit(ProfileErrorState(onError.toString()));
    });
  }
}
