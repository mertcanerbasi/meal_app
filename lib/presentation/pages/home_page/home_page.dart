import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meal_app/core/cubits/home_cubit/home_cubit.dart';
import 'package:meal_app/core/cubits/home_cubit/home_states.dart';
import 'package:meal_app/core/data/models/meal_type_model/meal_type_model.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:meal_app/presentation/pages/profile_page/profile_page.dart';
import 'package:meal_app/presentation/pages/search_page/search_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    cubit.getMealsList();
    cubit.googleAds.loadBannerAd();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20.sp, right: 20.sp, left: 20.sp),
          child: BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is HomeInitialState) {
                return Container();
              } else if (state is HomeErrorState) {
                return BuildErrorWidget(
                  error: state.error,
                );
              } else if (state is HomeSuccessState) {
                return Column(
                  children: [
                    const WelcomeHomeWidget(),
                    SizedBox(height: 2.h),
                    GestureDetector(
                      onTap: () {
                        cubit.googleAds.disposeBannerAd();
                        navigateTo(context, SearchPage(), isFullScreen: true)
                            .then((value) {
                          cubit.googleAds.loadBannerAd();
                        });
                      },
                      child: DefaultTextFormField(
                          context: context,
                          isEnabled: false,
                          hintText: "Find some delicious recipes",
                          validator: null,
                          controller: controller,
                          type: TextInputType.name),
                    ),
                    SizedBox(height: 2.h),
                    BannerAdWidget(
                      bannerAd: cubit.googleAds.bannerAd,
                    ),
                    SizedBox(height: 2.h),
                    HorizontalChipListWidget(
                        mealTypesList: cubit.mealTypesList),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return FoodSuggestionItemWidget(
                              mealModel: cubit.currentMealsList[index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 2.h);
                        },
                        itemCount: cubit.currentMealsList.length,
                      ),
                    ),
                  ],
                );
              } else {
                return const LoadingWidget();
              }
            },
          ),
        ),
      ),
    );
  }
}

class WelcomeHomeWidget extends StatelessWidget {
  const WelcomeHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Mertcan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                  fontSize: 18.sp,
                ),
              ),
              Text(
                "What would you like to cook today?",
                style: TextStyle(
                  color: AppColors.secondaryFontColor,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              navigateTo(context, const ProfilePage());
            },
            child: CircleAvatar(
              radius: 3.h,
              backgroundColor: AppColors.mainColor,
              backgroundImage: (FirebaseAuth.instance.currentUser != null &&
                      FirebaseAuth.instance.currentUser!.photoURL != null)
                  ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class BannerAdWidget extends StatelessWidget {
  final BannerAd? bannerAd;
  const BannerAdWidget({super.key, this.bannerAd});

  @override
  Widget build(BuildContext context) {
    if (bannerAd != null) {
      return Container(
        height: 15.h,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: AdWidget(ad: bannerAd!),
      );
    } else {
      return const SizedBox();
    }
  }
}

class HorizontalChipListWidget extends StatelessWidget {
  final List<MealTypeModel> mealTypesList;
  const HorizontalChipListWidget({super.key, required this.mealTypesList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.h,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                HomeCubit.get(context).changeMealType(index);
              },
              child: Container(
                width: 25.w,
                decoration: BoxDecoration(
                  color: mealTypesList[index].isSelected
                      ? AppColors.mainColor.shade100
                      : AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Center(
                    child: Text(
                  mealTypesList[index].label,
                  style: TextStyle(
                      color: mealTypesList[index].isSelected
                          ? AppColors.mainColor
                          : null,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold),
                )),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
                width: 2.w,
              ),
          itemCount: mealTypesList.length),
    );
  }
}
