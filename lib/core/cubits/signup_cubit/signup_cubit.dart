import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/signup_cubit/signup_states.dart';
import 'package:meal_app/core/data/models/user_model/user_model.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  void registerUser({
    required String name,
    required String email,
    required String password,
  }) {
    emit(RegisterUserLoadingsState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
        uId: value.user!.uid,
        name: name,
        email: email,
      );
      emit(RegisterUserSuccessState());
    }).catchError((error) {
      emit(RegisterUserErrorState(error.toString()));
    });
  }

  void createUser({
    required String uId,
    required String name,
    required String email,
  }) {
    UserModel userModel = UserModel(
      uId: uId,
      name: name,
      photoUrl: null,
      email: email,
      createdAt: DateTime.now(),
      favoriteMealsList: [],
    );

    emit(CreateUserLoadingsState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toJson())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error));
    });
  }
}
