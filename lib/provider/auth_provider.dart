import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/choose_screen.dart';
import '../Screens/registration/registration_screen.dart';
import '../models/user_model.dart';
import '../router/app_router.dart';
import '../services/auth_helper.dart';
import '../services/firestore_helper.dart';

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
    //ChooseCardScreen()
  }

  getCurrentUser() {
    currentUser = AuthHelper.authHelper.getCurrentUser();

    notifyListeners();
  }

  void signUpWithEmailAndPassword(
      {required email,
      required password,
      required userName,
      required context}) async {
    print('signUpwithemailandpassword');
    UserCredential? userCredential = await AuthHelper.authHelper
        .signUpWithEmailAndPassword(email, password, context);
    if (userCredential != null) {
      String userId = userCredential.user!.uid;

      UserModel user = UserModel(email: email, userName: userName, id: userId);
      await addUserToFirestore(user: user);
    }
    getCurrentUser();
  }

  Future<bool> signInWithEmailAndPassword(
      {required email, required password, required context}) async {
    bool isSigned = await AuthHelper.authHelper
        .signInWithEmailAndPassword(email, password, context);
    getCurrentUser();
    return isSigned;
  }

  addUserToFirestore({required UserModel user}) async {
    await FirestoreHelper.firestoreHelper.addUser(user: user);
  }

  void signOut() {
    AuthHelper.authHelper.signOut();
    getCurrentUser();
  }
}
