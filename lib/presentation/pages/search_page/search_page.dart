import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/search_cubit/search_cubit.dart';
import 'package:meal_app/core/cubits/search_cubit/search_states.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = SearchCubit.get(context);
    cubit.getMealsList();

    return Scaffold(
      appBar: DefaultAppBar(
        title: "Find Delicious Recipes",
        context: context,
        actions: [
          IconButton(
              onPressed: () {
                searchController.clear();
                cubit.getMealsList();
              },
              icon: const Icon(
                Icons.delete,
                color: AppColors.mainColor,
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.mainColor,
        onPressed: () {
          cubit.getMealsWithContainsName(searchController.text);
        },
        icon: const Icon(
          Icons.search,
          color: AppColors.backgroundColor,
        ),
        label: Text(
          "Search",
          style: TextStyle(color: AppColors.backgroundColor, fontSize: 16.sp),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20.sp, right: 20.sp, left: 20.sp),
          child: BlocConsumer<SearchCubit, SearchStates>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is SearchSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const BuildHeader(title: "Search for recipes"),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              cubit.decreasePageNumber();
                            },
                            icon: Icon(
                              Icons.chevron_left,
                              color: cubit.isDecreasable()
                                  ? AppColors.mainColor
                                  : AppColors.iconBackgroundColor,
                              size: 18.sp,
                            )),
                        Text(
                          "${cubit.pageNumber}/${cubit.totalPage}",
                          style: TextStyle(
                              fontSize: 16.sp, color: AppColors.mainColor),
                        ),
                        IconButton(
                            onPressed: () {
                              cubit.increasePageNumber();
                            },
                            icon: Icon(
                              Icons.chevron_right,
                              color: cubit.isIncreasable()
                                  ? AppColors.mainColor
                                  : AppColors.iconBackgroundColor,
                              size: 18.sp,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    TextField(
                      cursorColor: AppColors.mainColor,
                      controller: searchController,
                      style: TextStyle(fontSize: 16.sp),
                      decoration: const InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
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
              }
              if (state is SearchedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const BuildHeader(title: "Search for recipes"),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              cubit.decreasePageNumberSearched();
                            },
                            icon: Icon(
                              Icons.chevron_left,
                              color: cubit.isDecreasable()
                                  ? AppColors.mainColor
                                  : AppColors.iconBackgroundColor,
                              size: 18.sp,
                            )),
                        Text(
                          "${cubit.pageNumber}/${cubit.totalPageForSearched}",
                          style: TextStyle(
                              fontSize: 16.sp, color: AppColors.mainColor),
                        ),
                        IconButton(
                            onPressed: () {
                              cubit.increasePageNumberSearched();
                            },
                            icon: Icon(
                              Icons.chevron_right,
                              color: cubit.isIncreasableSearched()
                                  ? AppColors.mainColor
                                  : AppColors.iconBackgroundColor,
                              size: 18.sp,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    TextField(
                      cursorColor: AppColors.mainColor,
                      controller: searchController,
                      style: TextStyle(fontSize: 16.sp),
                      decoration: const InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return FoodSuggestionItemWidget(
                              mealModel: cubit.searchedMealsList[index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 2.h);
                        },
                        itemCount: cubit.searchedMealsList.length,
                      ),
                    ),
                  ],
                );
              } else if (state is SearchError) {
                return BuildErrorWidget(
                  error: state.error,
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
