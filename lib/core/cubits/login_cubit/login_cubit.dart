import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meal_app/core/data/models/user_model/user_model.dart';

import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void createUser(UserCredential user) async {
    UserModel userModel = UserModel(
        uId: user.user!.uid,
        name: user.user!.displayName,
        email: user.user!.email,
        photoUrl: user.user!.photoURL,
        createdAt: DateTime.now(),
        favoriteMealsList: []);

    emit(CreateUserLoadingsState());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.user!.uid)
        .set(userModel.toJson())
        .then((value) {
      emit(CreateUserSuccessState(user.user!.uid));
    }).catchError((error) {
      emit(CreateUserErrorState(error));
    });
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(UserLoginLoadingsState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(UserLoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(UserLoginErrorState(error.toString()));
    });
  }

  void logInWithGoogle() async {
    emit(SignInGoogleLoadingsState());
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
            clientId:
                "75820450814-607hsrb3n5coa06j8k81una616tlisqc.apps.googleusercontent.com")
        .signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      createUser(user);
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }
}
