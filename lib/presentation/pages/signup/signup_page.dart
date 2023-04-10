import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/signup_cubit/signup_cubit.dart';
import 'package:meal_app/core/cubits/signup_cubit/signup_states.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:meal_app/presentation/pages/login/login_page.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (BuildContext context, state) {
          if (state is CreateUserSuccessState) {
            navigateAndFinish(context, LoginPage());
          }
        },
        builder: (BuildContext context, Object? state) {
          return Scaffold(
            //resizeToAvoidBottomInset: false,
            body: Form(
              key: _formKey,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BuildHeader(title: context.l10n.signUp),
                        SizedBox(
                          height: 1.h,
                        ),
                        BuildSecondHeader(title: context.l10n.signUpSubtitle),
                        SizedBox(
                          height: 3.h,
                        ),
                        DefaultTextFormField(
                          context: context,
                          hintText: context.l10n.name,
                          validator: qValidator([
                            IsRequired(),
                          ]),
                          controller: nameController,
                          type: TextInputType.name,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        DefaultTextFormField(
                          context: context,
                          hintText: context.l10n.email,
                          validator: qValidator([
                            IsRequired(),
                            const IsEmail(),
                          ]),
                          controller: emailController,
                          type: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        DefaultTextFormField(
                          context: context,
                          hintText: context.l10n.password,
                          validator: qValidator([
                            IsRequired(),
                            MinLength(6),
                          ]),
                          controller: passwordController,
                          type: TextInputType.text,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        DefaultTextFormField(
                          context: context,
                          hintText: context.l10n.confirmPassword,
                          validator: (String? value) {
                            if (value != passwordController.text) {
                              return context.l10n.passwordControlError;
                            }
                            return null;
                          },
                          controller: confirmPasswordController,
                          type: TextInputType.text,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        BuildCondition(
                          condition: state is! RegisterUserLoadingsState,
                          builder: (context) => DefaultButton(
                            color: AppColors.mainColor,
                            title: context.l10n.signUp,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                SignUpCubit.get(context).registerUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                          ),
                          fallback: (context) =>
                              const CircularProgressIndicator(),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BuildSecondHeader(
                              title: context.l10n.alreadyHaveAccount,
                            ),
                            DefaultTextButton(
                              child: context.l10n.login,
                              onPressed: () {
                                navigateAndFinish(context, LoginPage());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
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
