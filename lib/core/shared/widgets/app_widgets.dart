import 'package:flutter/material.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BuildHeader extends StatelessWidget {
  final String title;
  final TextAlign? textAlign;

  const BuildHeader({
    Key? key,
    required this.title,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: TextStyle(
        color: AppColors.primaryFontColor,
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
      ),
    );
  }
}

class BuildSecondHeader extends StatelessWidget {
  final String title;

  final TextAlign? textAlign;

  const BuildSecondHeader({
    Key? key,
    required this.title,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: TextStyle(color: AppColors.secondaryFontColor, fontSize: 16.sp),
    );
  }
}

class DefaultButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback onPressed;
  final Color textColor;
  final double width;
  final double height;

  const DefaultButton({
    Key? key,
    this.color = AppColors.mainColor,
    required this.title,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 56,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      textColor: textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      height: height,
      minWidth: width,
      child: Text(
        title,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
