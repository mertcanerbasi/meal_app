import 'package:flutter/material.dart';
import 'package:meal_app/core/helpers/cache_helper.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:meal_app/core/shared/utils/utils.dart';
import 'package:meal_app/core/shared/widgets/app_widgets.dart';
import 'package:meal_app/presentation/layouts/intro_layout/intro_layout.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatelessWidget {
  final List<String> images = const [
    'assets/images/on_boarding_3.png',
    'assets/images/on_boarding_2.png',
    'assets/images/on_boarding_1.png',
  ];

  final PageController controller = PageController();

  OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      context.l10n.onBoarding1Title,
      context.l10n.onBoarding2Title,
      context.l10n.onBoarding3Title,
    ];
    List<String> descriptions = [
      context.l10n.onBoarding1Subtitle,
      context.l10n.onBoarding2Subtitle,
      context.l10n.onBoarding3Subtitle,
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      images[index],
                      height: 35.h,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    BuildHeader(
                      title: titles[index],
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: BuildSecondHeader(
                        title: descriptions[index],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: images.length,
              ),
            ),
            SmoothPageIndicator(
              effect: ExpandingDotsEffect(
                dotColor: Colors.grey,
                activeDotColor: AppColors.mainColor,
                dotHeight: 1.h,
                expansionFactor: 5,
                dotWidth: 5.w,
                spacing: 2.w,
              ),
              controller: controller,
              count: images.length,
            ),
            SizedBox(
              height: 3.h,
            ),
            DefaultButton(
              title: context.l10n.next.toUpperCase(),
              onPressed: () {
                CacheHelper.saveData(key: 'onBoarding', value: true)
                    .then((value) {
                  navigateAndFinish(context, const IntroLayout());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
