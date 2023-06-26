import 'dart:async';
import 'package:day_tracker_graduation/Screens/choose_screen.dart';
import 'package:day_tracker_graduation/Screens/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      AppRouter.router.pushWithReplacementFunction(RegistrationScreen(
        type: RegistrationType.signIn,
      ));
      // AppRouter.router.pushWithReplacementFunction(ChooseCardScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 215.w,
          height: 203.h,
        ),
      ),
    );
  }
}
