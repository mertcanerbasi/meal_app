import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:meal_app/core/cubits/profile_cubit/profile_states.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ProfileCubit.get(context);
    cubit.getCurrentUser(uId: FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      appBar: DefaultAppBar(
        context: context,
        title: context.l10n.profile,
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
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22.sp,
                          backgroundImage: NetworkImage(
                            cubit.currentUser?.photoUrl ??
                                'https://www.w3schools.com/howto/img_avatar.png',
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                cubit.currentUser!.name ?? "Chef",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cooking Since : ${cubit.currentUser!.createdAt.toString().substring(0, 10)}",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "About Me",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
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
