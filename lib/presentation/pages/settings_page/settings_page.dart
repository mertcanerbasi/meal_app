import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:meal_app/core/cubits/app_cubit/app_cubit.dart';
import 'package:meal_app/core/cubits/app_cubit/app_states.dart';
import 'package:meal_app/core/shared/utils/constants.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:meal_app/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InAppReview inAppReview = InAppReview.instance;
    return Scaffold(
      appBar: DefaultAppBar(
        title: (context.l10n.settings),
        context: context,
      ),
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Padding(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                children: [
                  BuildItem(
                    title: context.l10n.language,
                    icon: Icon(
                      Icons.language,
                      color: Colors.black,
                      size: 25.sp,
                    ),
                    onPressed: () {
                      showActionMenu(context, actions: [
                        Column(
                          children: [
                            ListTile(
                              leading: const CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/turkey.png"),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(
                                "Türkçe",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                MyApp.setLocale(context, "tr");
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage(
                                    "assets/images/united-kingdom.png"),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(
                                "English",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                MyApp.setLocale(context, "en");
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        )
                      ]);
                    },
                  ),
                  BuildItem(
                    onPressed: () async {
                      if (await inAppReview.isAvailable()) {
                        unawaited(inAppReview.requestReview());
                      }
                    },
                    icon: Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 25.sp,
                    ),
                    title: context.l10n.rate,
                  ),
                  BuildItem(
                    onPressed: () async {
                      Share.share(
                          Platform.isAndroid ? androidStoreLink : iosStoreLink);
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 25.sp,
                    ),
                    title: context.l10n.share,
                  ),
                  BuildItem(
                    title: context.l10n.signOut,
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                      size: 25.sp,
                    ),
                    onPressed: () => cubit.signOut(context),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class BuildItem extends StatelessWidget {
  static const Color itemColor = Color(0xffF6F6F6);
  final String title;
  final Icon icon;
  VoidCallback? onPressed;

  BuildItem({
    Key? key,
    required this.title,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 10.h,
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20.sp,
                    child: icon,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
