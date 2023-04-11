import 'package:meal_app/core/data/models/user_model/user_model.dart';

abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {
  final UserModel currentUser;

  ProfileSuccessState({required this.currentUser});
}

class ProfileErrorState extends ProfileStates {
  final String error;

  ProfileErrorState(this.error);
}
