import 'package:flutter/material.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:meal_app/presentation/pages/login/login_page.dart';
import 'package:meal_app/presentation/pages/signup/signup_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IntroLayout extends StatelessWidget {
  const IntroLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 20.sp),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: Image.asset(
                  'assets/images/mealLogo.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.appName,
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      context.l10n.introSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 5.h),
                    DefaultButton(
                      color: AppColors.mainColor,
                      title: context.l10n.login,
                      onPressed: () {
                        navigateAndFinish(context, LoginPage());
                      },
                    ),
                    SizedBox(height: 2.h),
                    MaterialButton(
                      textColor: AppColors.mainColor,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: AppColors.mainColor),
                      ),
                      onPressed: () {
                        navigateAndFinish(context, SignUpPage());
                      },
                      height: 56,
                      minWidth: double.infinity,
                      child: Text(
                        context.l10n.createAccount,
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
