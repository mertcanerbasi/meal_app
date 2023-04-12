import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:meal_app/core/cubits/profile_cubit/profile_states.dart';
import 'package:meal_app/core/data/models/user_model/user_model.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:meal_app/presentation/pages/create_recipe_page/create_recipe_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ProfileCubit.get(context);
    cubit.getCurrentUser(uId: FirebaseAuth.instance.currentUser!.uid);
    cubit.getAllMealsWithCurrentUserId();
    return Scaffold(
      appBar: DefaultAppBar(
        context: context,
        title: context.l10n.profile,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.sp),
        ),
        label: Text(
          context.l10n.addRecipe,
          style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.backgroundColor),
        ),
        onPressed: () {
          navigateTo(context, const CreateReceipePage(), isFullScreen: true)
              .then((value) => cubit.getAllMealsWithCurrentUserId());
        },
        icon: const Icon(
          Icons.restaurant,
          color: AppColors.backgroundColor,
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 20.sp, right: 20.sp, left: 20.sp),
        child: BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ProfileSuccessState) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileTopWidget(
                      currentUser: cubit.currentUser,
                    ),
                    SizedBox(height: 5.h),
                    AboutUserSectionWidget(
                      numberOfFavoriteMeals: cubit.numberOfFavoriteFoods,
                      numberOfOwnRecepies: cubit.numberOfUsersMealsLength,
                    ),
                  ]);
            } else if (state is ProfileErrorState) {
              return BuildErrorWidget(error: state.error);
            } else {
              return const LoadingWidget();
            }
          },
        ),
      )),
    );
  }
}

class ProfileTopWidget extends StatelessWidget {
  final UserModel? currentUser;
  const ProfileTopWidget({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22.sp,
          backgroundImage: NetworkImage(
            currentUser?.photoUrl ??
                'https://www.w3schools.com/howto/img_avatar.png',
          ),
        ),
        SizedBox(width: 2.w),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                currentUser!.name ?? "Chef",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cooking Since : ${currentUser!.createdAt.toString().substring(0, 10)}",
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ]),
      ],
    );
  }
}

class AboutUserSectionWidget extends StatelessWidget {
  final int? numberOfFavoriteMeals;
  final int? numberOfOwnRecepies;
  const AboutUserSectionWidget(
      {super.key, this.numberOfFavoriteMeals, this.numberOfOwnRecepies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User Stats",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Text(
              "Number of favorite foods",
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const Spacer(),
            Text(
              "${numberOfFavoriteMeals ?? "0"}",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryFontColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Text(
              "Number of own recepies",
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const Spacer(),
            Text(
              "${numberOfOwnRecepies ?? "0"}",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryFontColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
