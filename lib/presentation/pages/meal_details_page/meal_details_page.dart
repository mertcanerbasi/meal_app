import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meal_app/core/cubits/meal_details_cubit/meail_details_cubit.dart';
import 'package:meal_app/core/cubits/meal_details_cubit/meail_details_states.dart';
import 'package:meal_app/core/data/models/meal_model/meal_model.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MealDetailsPage extends StatelessWidget {
  final MealModel mealModel;
  const MealDetailsPage({super.key, required this.mealModel});

  @override
  Widget build(BuildContext context) {
    var cubit = MealDetailsCubit.get(context);
    cubit.getFavoriteMealsListFromFirebase(id: mealModel.mealId);
    return BlocConsumer<MealDetailsCubit, MealDetailsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MealDetailsSuccessState) {
          return Scaffold(
              appBar: DefaultAppBar(
                title: "Receipt",
                context: context,
                actions: [
                  IconButton(
                    onPressed: () {
                      cubit.handleFavorite();
                    },
                    icon: Icon(
                      Icons.favorite,
                      size: 20.sp,
                      color: cubit.isFavorite
                          ? AppColors.mainColor
                          : AppColors.primaryFontColor,
                    ),
                  )
                ],
              ),
              body: Padding(
                  padding:
                      EdgeInsets.only(top: 20.sp, right: 20.sp, left: 20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 25.h,
                        width: 100.w,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.sp)),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: mealModel.image,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      SizedBox(
                        height: 8.h,
                        width: 100.w,
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Rating",
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(mealModel.likes.toString())
                              ],
                            )),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Minutes",
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(mealModel.minutes.toString())
                              ],
                            )),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(mealModel.name,
                          style: TextStyle(
                            color: AppColors.primaryFontColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          )),
                      SizedBox(height: 2.h),
                      SizedBox(
                        height: 5.h,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 2.w),
                          scrollDirection: Axis.horizontal,
                          itemCount: mealModel.tags.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor.shade100,
                                borderRadius: BorderRadius.circular(10.sp),
                              ),
                              child: Center(
                                  child: Text(
                                mealModel.tags[index],
                                style: TextStyle(
                                    color: AppColors.mainColor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              )),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text("Ingredients",
                          style: TextStyle(
                            color: AppColors.primaryFontColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          )),
                      SizedBox(height: 2.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: mealModel.ingredients.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const FaIcon(
                                FontAwesomeIcons.circleCheck,
                                color: AppColors.mainColor,
                              ),
                              title: Text(
                                mealModel.ingredients[index],
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )));
        } else if (state is MealDetailsErrorState) {
          return Scaffold(body: BuildErrorWidget(error: state.error));
        } else {
          return const Scaffold(
            body: LoadingWidget(),
          );
        }
      },
    );
  }
}
