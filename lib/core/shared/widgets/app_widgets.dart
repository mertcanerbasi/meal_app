import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class DefaultTextFormField extends StatelessWidget {
  final BuildContext context;
  final String hintText;
  final String? Function(String? val)? validator;
  final TextEditingController controller;
  final TextInputType type;
  final bool isPassword;
  const DefaultTextFormField({
    Key? key,
    required this.context,
    required this.hintText,
    required this.validator,
    required this.controller,
    required this.type,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      cursorColor: AppColors.mainColor,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.textFieldColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.textFieldColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.textFieldColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.textFieldColor,
          ),
        ),
        filled: true,
        fillColor: AppColors.textFieldColor,
        contentPadding: const EdgeInsets.only(left: 34, top: 40),
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class DefaultTextButton extends StatelessWidget {
  final Color? color;
  final String child;
  final VoidCallback onPressed;
  final FontWeight fontWeight;

  const DefaultTextButton({
    Key? key,
    this.color,
    this.fontWeight = FontWeight.bold,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        child,
        style: TextStyle(
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

class RawButton extends StatelessWidget {
  final Color buttonColor;
  final String text;
  final String image;
  final VoidCallback onPressed;

  const RawButton({
    Key? key,
    required this.buttonColor,
    required this.text,
    required this.image,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: buttonColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      height: 56,
      minWidth: double.infinity,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(image),
          const SizedBox(width: 32.4),
          Text(text),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset("assets/images/loading.gif"));
  }
}

class BuildErrorWidget extends StatelessWidget {
  final String? error;
  const BuildErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/error.png"))),
          ),
        ),
        Expanded(
            child: Text(
          error ?? "Something went wrong",
          style: Theme.of(context).textTheme.bodyLarge,
        ))
      ],
    );
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? color;
  final Color? backgroundColor;
  final double? elevation;
  final Color? iconColor;
  final BuildContext context;
  final List<Widget>? actions;

  const DefaultAppBar({
    Key? key,
    required this.title,
    this.color,
    this.backgroundColor,
    this.elevation,
    this.iconColor,
    required this.context,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: AppColors.primaryFontColor),
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      elevation: elevation,
      title: Text(
        title,
        style: TextStyle(fontSize: 18.sp, color: AppColors.primaryFontColor),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
