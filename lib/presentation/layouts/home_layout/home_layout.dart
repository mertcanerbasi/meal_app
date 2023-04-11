import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meal_app/core/cubits/app_cubit/app_cubit.dart';
import 'package:meal_app/core/cubits/app_cubit/app_states.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (value) {
                cubit.changeIndex(value);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.house,
                    size: 23.sp,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_outline,
                    size: 23.sp,
                  ),
                  label: "Favorites",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                    size: 23.sp,
                  ),
                  label: "Settings",
                ),
              ],
            ),
            body: cubit.pages[cubit.currentIndex],
          );
        },
      ),
    );
  }
}
