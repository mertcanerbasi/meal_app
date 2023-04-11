import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meal_app/core/cubits/favorites_cubit/favorites_cubit.dart';
import 'package:meal_app/core/cubits/favorites_cubit/favorites_states.dart';
import 'package:meal_app/core/data/models/meal_model/meal_model.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:meal_app/presentation/pages/meal_details_page/meal_details_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = FavoritesCubit.get(context);
    cubit.getFavorites();

    return Scaffold(
      appBar: DefaultAppBar(title: "My Favorites", context: context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20.sp, right: 20.sp, left: 20.sp),
          child: BlocConsumer<FavoritesCubit, FavoritesStates>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is FavoritesSuccessState) {
                if (state.favoriteMealsList.isNotEmpty) {
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return BuildMealItem(
                        meal: state.favoriteMealsList[index],
                        whenFinished: () {
                          cubit.getFavorites();
                        },
                      );
                    },
                    itemCount: state.favoriteMealsList.length,
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/images/mealLogo.png",
                        height: 25.h,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "You have no favorites yet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  );
                }
              } else if (state is FavoritesErrorState) {
                return BuildErrorWidget(error: state.error);
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

class BuildMealItem extends StatelessWidget {
  final MealModel meal;
  final VoidCallback? whenFinished;

  const BuildMealItem({super.key, required this.meal, this.whenFinished});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        navigateTo(context, MealDetailsPage(mealModel: meal),
                isFullScreen: true)
            .then((value) => whenFinished?.call());
      },
      leading: Container(
        height: 10.h,
        width: 20.w,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.sp),
          color: Colors.grey[300],
        ),
        child: CachedNetworkImage(
          height: 25.h,
          width: 25.h,
          fit: BoxFit.cover,
          imageUrl: meal.image,
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      title: Text(
        meal.name,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "${meal.minutes} min",
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(
          FontAwesomeIcons.heartCrack,
          color: AppColors.mainColor,
        ),
        onPressed: () {},
      ),
    );
  }
}
