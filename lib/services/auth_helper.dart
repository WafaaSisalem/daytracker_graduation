import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class AuthHelper {
  AuthHelper._();
  static AuthHelper authHelper = AuthHelper._();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//EMAIL SIGN UP

  signUpWithEmailAndPassword(email, password, context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      sendEmailVerification(context);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('You enterd a too weak password please change it',
            context: context);
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.',
            context: context);
      }
    }
  }

// EMAIL VERFICATION
  Future<void> sendEmailVerification(context) async {
    try {
      firebaseAuth.currentUser!.sendEmailVerification();
      showToast('Email verfication has been sent!', context: context);
    } on FirebaseAuthException catch (e) {
      showToast(context: context, e.message);
    }
  }

  Future<bool> signInWithEmailAndPassword(email, password, context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (!firebaseAuth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
      return userCredential.user == null ? false : true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('No user found for that email.', context: context);
      } else if (e.code == 'wrong-password') {
        showToast('Wrong password provided for that user.', context: context);
      }
      return false;
    }
  }

  // Future resetPassword(email) async {
  //   try {
  //     return await firebaseAuth.sendPasswordResetEmail(email: email);
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e.toString() + 'resetPassword');
  //   }
  // }
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  Future signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString() + 'signOut');
    }
  }
}
