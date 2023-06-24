import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Screens/splash_screen.dart';
import 'router/app_router.dart';

void main() {
  runApp(
    ScreenUtilInit(
      builder: (context, child) => const MyApp(),
      designSize: const Size(375, 812),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const primaryColor = Color(0xFF9A5DBA);
  static const secondaryColor = Color(0xFF892BB9);
  static const scaffoldBackgroundColor = Color(0xFFFBFBFB);
  static const shadowColor = Color(0x28000000);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppRouter.router.routerKey,
      theme: appThemeData(),
      routes: {
        '/': (context) => const SplashScreen(),
      },
      // onGenerateRoute: (routeSettings) {
      //   String? name = routeSettings.name;
      //   var arguments = routeSettings.arguments;
      //   return MaterialPageRoute(builder: (context) {
      //     if (name == RegistrationScreen.routeName) {
      //       return RegistrationScreen(
      //           type: (arguments as List)[0] as RegistrationType);
      //     } else {
      //       return const Scaffold(
      //         body: Text('ERROR 404!'),
      //       );
      //     }
      //   });
      // },
    );
  }

  ThemeData appThemeData() {
    return ThemeData(
      fontFamily: 'Poppins',
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: primaryColor,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      primaryColor: primaryColor,
      colorScheme: ThemeData().colorScheme.copyWith(secondary: secondaryColor),
      textTheme: ThemeData.light().textTheme.copyWith(
          headline1: TextStyle(
            color: secondaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
          headline2: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600),
          headline3: TextStyle(
              color: Colors.black,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600),
          headline4: TextStyle(
            color: Colors.black,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          headline6: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: secondaryColor),
          subtitle1: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
          subtitle2: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black)),
    );
  }
}
