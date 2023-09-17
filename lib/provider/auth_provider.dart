import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/choose_screen.dart';
import '../Screens/registration/registration_screen.dart';
import '../models/user_model.dart';
import '../router/app_router.dart';
import '../services/auth_helper.dart';
import '../services/firestore_helper.dart';
import '../utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  User? currentUser;
  UserModel? userModel;
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

  getUserModel() async {
    QuerySnapshot userQuery =
        await FirestoreHelper.firestoreHelper.getUserModel();
    QueryDocumentSnapshot userMap = userQuery.docs[0];
    userModel = UserModel(
        email: userMap[Constants.emailKey],
        userName: userMap[Constants.userNameKey],
        id: userMap[Constants.idKey],
        masterPassword: userMap[Constants.masterPassKey]);
  }

  getCurrentUser() {
    currentUser = AuthHelper.authHelper.getCurrentUser();
    if (currentUser != null) {
      getUserModel();
    }
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

  void updatePassword(String masterPass) async {
    UserModel newUser = UserModel.fromMap(
        {...userModel!.toMap(), Constants.masterPassKey: masterPass});
    await FirestoreHelper.firestoreHelper.updateUser(newUser);
  }
}
