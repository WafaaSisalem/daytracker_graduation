import 'package:audioplayers/audioplayers.dart';
import 'package:day_tracker_graduation/Screens/master_password_screen.dart';
import 'package:day_tracker_graduation/Screens/pomos/home/break_screen.dart';
import 'package:day_tracker_graduation/Screens/pomos/home/go_on_screen.dart';
import 'package:day_tracker_graduation/Screens/pomos/home/got_pomo_screen.dart';
import 'package:day_tracker_graduation/models/note_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:day_tracker_graduation/provider/pomo_provider.dart';
import 'package:day_tracker_graduation/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'Screens/pomos/home/home_screen.dart';
import 'Screens/registration/registration_screen.dart';
import 'Screens/splash_screen.dart';
import 'helpers/shared_preference_helper.dart';
import 'router/app_router.dart';

late AudioPlayer audioPlayer;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  audioPlayer = AudioPlayer();
  await Firebase.initializeApp();
  await SharedPreferenceHelper.sharedHelper.initSharedPreferences();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    loadAudioFile().then((value) {
      runApp(ScreenUtilInit(
        builder: (context, child) => MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
                create: (context) => AuthProvider()),
            ChangeNotifierProvider<PomoProvider>(
                create: (context) => PomoProvider()),
            ChangeNotifierProvider<NoteProvider>(
                create: (context) => NoteProvider()),
            ChangeNotifierProvider<JournalProvider>(
                create: (context) => JournalProvider()),
          ],
          child: const MyApp(),
        ),
        designSize: const Size(375, 812),
      ));
    });
  });
}

Future<void> loadAudioFile() async {
  await audioPlayer.setReleaseMode(ReleaseMode.stop);
  await audioPlayer.setSourceAsset('audios/break.wav');
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
      debugShowCheckedModeBanner: false,
      theme: appThemeData(),
      routes: {
        '/': (context) => const SplashScreen(),
        Constants.gotPomoScreen: (context) => const GotPomoScreen(),
        Constants.breakScreen: (context) => BreakScreen(),
        Constants.goOn: (context) => const GgOnScreen(),
        Constants.homeScreen: (context) => const HomeScreen(),
      },
      onGenerateRoute: (routeSettings) {
        String? name = routeSettings.name;
        var arguments = routeSettings.arguments;
        return MaterialPageRoute(builder: (context) {
          if (name == RegistrationScreen.routeName) {
            return RegistrationScreen(
                type: (arguments as List)[0] as RegistrationType);
          } else if (name == MasterPassScreen.routeName) {
            return MasterPassScreen(item: (arguments as List)[0] as NoteModel);
          } else {
            return const Scaffold(
              body: Text('ERROR 404!'),
            );
          }
        });
      },
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
