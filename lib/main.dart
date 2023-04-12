// ignore_for_file: invalid_use_of_protected_member, deprecated_member_use

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meal_app/core/cubits/app_cubit/app_cubit.dart';
import 'package:meal_app/core/cubits/create_recipe_cubit/create_recipe_cubit.dart';
import 'package:meal_app/core/cubits/favorites_cubit/favorites_cubit.dart';
import 'package:meal_app/core/cubits/home_cubit/home_cubit.dart';
import 'package:meal_app/core/cubits/meal_details_cubit/meail_details_cubit.dart';
import 'package:meal_app/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:meal_app/core/helpers/cache_helper.dart';
import 'package:meal_app/core/shared/theme/app_theme.dart';
import 'package:meal_app/core/shared/utils/bloc_observer.dart';
import 'package:meal_app/firebase_options.dart';
import 'package:meal_app/presentation/pages/login/login_page.dart';
import 'package:meal_app/presentation/pages/onboarding/onboarding_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'presentation/layouts/home_layout/home_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //Transparent Statusbar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await CacheHelper.init();
  Widget startWidget;
  //CacheHelper.removeData("onBoarding");
  var onBoarding = CacheHelper.getData(key: 'onBoarding');
  String? uId = CacheHelper.getData(key: 'uId');

  if (onBoarding != null) {
    if (uId != null) {
      startWidget = const HomeLayout();
    } else {
      startWidget = LoginPage();
    }
  } else {
    startWidget = OnBoardingPage();
  }

  BlocOverrides.runZoned(
    () {
      runApp(DevicePreview(
        enabled: kDebugMode,
        builder: (context) => MyApp(
          startWidget: startWidget,
        ),
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatefulWidget {
  final Widget startWidget;

  const MyApp({
    Key? key,
    required this.startWidget,
  }) : super(key: key);

  static void setLocale(BuildContext context, String newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();

    CacheHelper.saveData(key: "languageCode", value: newLocale);

    state?.setState(() {
      state._localCode = newLocale;
    });
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _localCode = "en";

  @override
  void initState() {
    super.initState();
    _fetchLocale().then((value) {
      setState(() {
        _localCode = value;
      });
    });
  }

  Future<String> _fetchLocale() async {
    String languageCode =
        await CacheHelper.getData(key: "languageCode") ?? "en";

    return languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(create: (BuildContext context) => AppCubit()),
        BlocProvider<HomeCubit>(
          create: (BuildContext context) => HomeCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: (BuildContext context) => ProfileCubit(),
        ),
        BlocProvider<MealDetailsCubit>(
          create: (BuildContext context) => MealDetailsCubit(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (BuildContext context) => FavoritesCubit(),
        ),
        BlocProvider<CreateRecipeCubit>(
          create: (BuildContext context) => CreateRecipeCubit(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: ResponsiveSizer(builder: (context, orientation, screenType) {
          return MaterialApp(
            useInheritedMediaQuery: true,
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            locale: Locale(_localCode),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.theme,
            home: widget.startWidget,
          );
        }),
      ),
    );
  }
}
