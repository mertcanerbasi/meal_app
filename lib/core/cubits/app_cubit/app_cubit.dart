import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/app_cubit/app_states.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/presentation/pages/favorites_page/favorites_page.dart';
import 'package:meal_app/presentation/pages/home_page/home_page.dart';
import 'package:meal_app/presentation/pages/login/login_page.dart';
import 'package:meal_app/presentation/pages/settings_page/settings_page.dart';

import '../../helpers/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    const FavoritesPage(),
    const SettingsPage(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppBottomNavBarState());
  }

  void signOut(context) {
    CacheHelper.removeData('uId').then((value) {
      if (value) {
        FirebaseAuth.instance.signOut().then((value) {
          navigateAndFinish(context, LoginPage());
        });
      }
    });
  }
}
