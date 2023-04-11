import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/profile_cubit/profile_states.dart';
import 'package:meal_app/core/data/models/meal_model/meal_model.dart';
import 'package:meal_app/core/data/models/user_model/user_model.dart';
import 'package:meal_app/core/shared/utils/constants.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/meal_type_model/meal_type_model.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  UserModel? currentUser;

  void createMeal() async {
    emit(ProfileLoadingState());
    String id = const Uuid().v4();
    MealModel mealModel = MealModel(
        name: "Grilled Chicken Wrap",
        chefUid: uId!,
        likes: 0,
        minutes: 25,
        mealTypes: MealType.lunch.name,
        mealId: id,
        ingredients: [
          "Grilled chicken breast",
          "Whole wheat tortilla wrap",
          "Lettuce",
          "Tomato",
          "Avacado",
          "Cucumber",
          "Onion",
          "Garlic sauce"
        ],
        tags: ["Healthy", "Low carb", "Low fat", "Low calorie"],
        image:
            "https://us.123rf.com/450wm/dml5050/dml50502101/dml5050210100054/162107892-classic-tortilla-wrap-roll-with-grilled-chicken-and-vegetables-tomato-lettuce-with-steam-smoke-on.jpg?ver=6");

    await FirebaseFirestore.instance
        .collection('meals')
        .doc(id)
        .set(mealModel.toJson())
        .then((value) {
      emit(ProfileSuccessState(currentUser: currentUser!));
    }).catchError((error) {
      emit(ProfileErrorState(error.toString()));
    });
  }

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
}
