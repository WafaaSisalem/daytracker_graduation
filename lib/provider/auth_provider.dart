import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/choose_screen.dart';
import '../Screens/registration/registration_screen.dart';
import '../router/app_router.dart';
import '../services/auth_helper.dart';

class AuthProvider extends ChangeNotifier {
  User? currentUser;

  AuthProvider() {
    getCurrentUser();
  }

  checkIsLogin() async {
    AppRouter.router.pushWithReplacementFunction(currentUser == null
        ? RegistrationScreen(
            type: RegistrationType.signIn,
          )
        : const ChooseCardScreen());
  }

  getCurrentUser() {
    currentUser = AuthHelper.authHelper.getCurrentUser();
    notifyListeners();
  }
}
