import 'package:flutter/material.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';

class AppTheme {
  static final AppTheme _instance = AppTheme._privateConstructor();

  AppTheme._privateConstructor();

  factory AppTheme() {
    return _instance;
  }

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Anuphan',
    primarySwatch: AppColors.mainColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      titleSpacing: 20,
      backgroundColor: AppColors.backgroundColor,
      //backwardsCompatibility: false,
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: Colors.transparent,
      // ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 18,
      selectedItemColor: AppColors.mainColor,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );
}
