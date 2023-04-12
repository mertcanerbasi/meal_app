import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/create_recipe_cubit/create_recipe_cubit.dart';
import 'package:meal_app/core/cubits/create_recipe_cubit/create_recipe_states.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:meal_app/core/shared/utils/constants.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateReceipePage extends StatelessWidget {
  const CreateReceipePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController indgredientsController = TextEditingController();
    TextEditingController tagController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var cubit = CreateRecipeCubit.get(context);
    return WillPopScope(
      onWillPop: () {
        cubit.clearState();
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor.withOpacity(0.95),
        appBar: DefaultAppBar(title: context.l10n.addRecipe, context: context),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.mainColor,
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                cubit.createRecipe(mealName: nameController.text);
              }
            },
            label: const Text(
              "Create Recipe",
              style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold),
            )),
        body: SafeArea(
          child: Padding(
            padding: paddingAll,
            child: BlocConsumer<CreateRecipeCubit, CreateRecipeStates>(
              listener: (context, state) {
                if (state is CreateRecipeSuccessState) {
                  cubit.clearState();
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                if (state is CreateRecipeErrorState) {
                  return BuildErrorWidget(error: state.error);
                } else if (state is CreateRecipeInitialState) {
                  return Form(
                    key: formKey,
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        DefaultTextFormField(
                            context: context,
                            hintText: "Meal Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a name";
                              } else if (value.length < 6) {
                                return "Name must be at least 6 characters";
                              }
                              return null;
                            },
                            controller: nameController,
                            type: TextInputType.name),
                        SizedBox(
                          height: 3.h,
                        ),
                        MealTypeSelectorWidget(
                          cubit: cubit,
                          mealType: cubit.mealType.name,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        IngredientsTagsSelectorWidget(
                          title: "Ingredients",
                          onPressed: () {
                            cubit.addIndgredient(indgredientsController.text);
                            indgredientsController.clear();
                          },
                          ingredientController: indgredientsController,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        SizedBox(
                          height: 5.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cubit.ingredientsList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 1.w),
                                child: Chip(
                                  onDeleted: () {
                                    cubit.removeIngredient(index);
                                  },
                                  deleteIconColor: AppColors.mainColor,
                                  label: Text(
                                    cubit.ingredientsList[index],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        IngredientsTagsSelectorWidget(
                          title: "Tags",
                          onPressed: () {
                            cubit.addTag(tagController.text);
                            tagController.clear();
                          },
                          ingredientController: tagController,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        SizedBox(
                          height: 5.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cubit.tags.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 1.w),
                                child: Chip(
                                  onDeleted: () {
                                    cubit.removeTag(index);
                                  },
                                  deleteIconColor: AppColors.mainColor,
                                  label: Text(
                                    cubit.tags[index],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Row(
                          children: [
                            Text(
                              "Upload Image",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                                onPressed: () async {
                                  await cubit.getImage();
                                },
                                icon: const Icon(
                                  Icons.photo,
                                  color: AppColors.mainColor,
                                ),
                                label: const Text(
                                  "Upload",
                                  style: TextStyle(color: AppColors.mainColor),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        if (cubit.image != null)
                          Container(
                            height: 30.h,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.sp)),
                            child: Image.file(
                              cubit.image!,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                      ],
                    ),
                  );
                } else {
                  return const LoadingWidget();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MealTypeSelectorWidget extends StatelessWidget {
  final CreateRecipeCubit cubit;
  final String mealType;
  const MealTypeSelectorWidget(
      {super.key, required this.cubit, required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Meal Type",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 30.w,
          child: DropdownButton(
            isExpanded: true,
            alignment: Alignment.center,
            iconEnabledColor: AppColors.mainColor,
            style: const TextStyle(color: AppColors.mainColor),
            value: mealType,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: "Breakfast",
                child: Text(
                  "Breakfast",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "Lunch",
                child: Text(
                  "Lunch",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "Dinner",
                child: Text(
                  "Dinner",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "Snack",
                child: Text(
                  "Snack",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              cubit.changeMealType(value.toString());
            },
          ),
        )
      ],
    );
  }
}

class IngredientsTagsSelectorWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final TextEditingController ingredientController;
  final String title;
  const IngredientsTagsSelectorWidget(
      {super.key,
      required this.onPressed,
      required this.ingredientController,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        const Spacer(),
        TextButton.icon(
            onPressed: () {
              showActionMenu(context, color: Colors.white, actions: [
                Padding(
                  padding: paddingAll,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "$title Name",
                            style: TextStyle(
                                color: AppColors.primaryFontColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          TextButton(
                              onPressed: () {
                                onPressed();
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.mainColor),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      DefaultTextFormField(
                          context: context,
                          hintText: title,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a name";
                            } else if (value.length < 6) {
                              return "Name must be at least 6 characters";
                            }
                            return null;
                          },
                          controller: ingredientController,
                          type: TextInputType.name),
                    ],
                  ),
                )
              ]);
            },
            icon: const Icon(
              Icons.add,
              color: AppColors.mainColor,
            ),
            label: Text(
              "Add $title",
              style: const TextStyle(color: AppColors.mainColor),
            ))
      ],
    );
  }
}
