import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _instance = AppColors._privateConstructor();

  AppColors._privateConstructor();

  factory AppColors() {
    return _instance;
  }

  static const MaterialColor mainColor = MaterialColor(
    0xffDC143C,
    <int, Color>{
      50: Color.fromRGBO(220, 20, 60, .1),
      100: Color.fromRGBO(220, 20, 60, .2),
      200: Color.fromRGBO(220, 20, 60, .3),
      300: Color.fromRGBO(220, 20, 60, .4),
      400: Color.fromRGBO(220, 20, 60, .5),
      500: Color.fromRGBO(220, 20, 60, .6),
      600: Color.fromRGBO(220, 20, 60, .7),
      700: Color.fromRGBO(220, 20, 60, .8),
      800: Color.fromRGBO(220, 20, 60, .9),
      900: Color.fromRGBO(220, 20, 60, 1),
    },
  );

  static const Color primaryFontColor = Color(0xff0B2633);
  static const Color secondaryFontColor = Color(0xff9DA5A8);
  static const Color textFieldColor = Color(0xffF2F2F2);
  static const Color iconBackgroundColor = Color(0xffE7EAF2);
  static const Color backgroundColor = Color(0xffFEFEFE);
}
