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
            return Column(
              children: const [],
            );
          },
        ),
      )),
    );
  }
}
