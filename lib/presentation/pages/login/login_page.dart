import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/login_cubit/login_cubit.dart';
import 'package:meal_app/core/cubits/login_cubit/login_states.dart';
import 'package:meal_app/core/helpers/cache_helper.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:meal_app/core/shared/utils/constants.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:meal_app/presentation/layouts/home_layout/home_layout.dart';
import 'package:meal_app/presentation/pages/signup/signup_page.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (BuildContext context, state) {
          if (state is UserLoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = state.uId;
              navigateAndFinish(context, const HomeLayout());
            });
          }
          if (state is CreateUserSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = state.uId;
              navigateAndFinish(context, const HomeLayout());
            });
          }
        },
        builder: (BuildContext context, Object? state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 20.sp, right: 20.sp, left: 20.sp),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BuildHeader(title: context.l10n.login),
                      SizedBox(
                        height: 1.h,
                      ),
                      BuildSecondHeader(title: context.l10n.loginSubtitle),
                      SizedBox(
                        height: 2.h,
                      ),
                      DefaultTextFormField(
                        context: context,
                        hintText: context.l10n.yourEmail,
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validator: qValidator([
                          IsRequired(),
                          const IsEmail(),
                        ]),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      DefaultTextFormField(
                        context: context,
                        hintText: context.l10n.password,
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        isPassword: true,
                        validator: qValidator([
                          IsRequired(),
                        ]),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      BuildCondition(
                        condition: state is! UserLoginLoadingsState,
                        builder: (context) => DefaultButton(
                          color: AppColors.mainColor,
                          title: context.l10n.login,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              LoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        fallback: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      DefaultTextButton(
                        child: context.l10n.forgotPassword,
                        color: AppColors.secondaryFontColor,
                        fontWeight: FontWeight.w400,
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      BuildSecondHeader(title: context.l10n.orLoginWith),
                      SizedBox(
                        height: 2.h,
                      ),
                      BuildCondition(
                        condition: state is! CreateUserLoadingsState,
                        builder: (context) => RawButton(
                          buttonColor: Colors.red,
                          text: context.l10n.loginWithGoogle,
                          image: 'assets/images/google.svg',
                          onPressed: () {
                            LoginCubit.get(context).logInWithGoogle();
                          },
                        ),
                        fallback: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      sizedBox28,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildSecondHeader(
                              title: context.l10n.dontHaveAccount),
                          DefaultTextButton(
                            child: context.l10n.signUp,
                            onPressed: () {
                              navigateAndFinish(context, SignUpPage());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
