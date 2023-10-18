import 'dart:io';

import 'package:day_tracker_graduation/Screens/choose_screen.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:day_tracker_graduation/provider/task_provider.dart';
import 'package:day_tracker_graduation/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../router/app_router.dart';
import '../../widgets/button_widget.dart';
import 'widgets/textfield_widget.dart';
import '../../utils/svgs/svgs.dart';

enum RegistrationType {
  signUp,
  signIn,
  forgetPassword,
}

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key? key, required this.type}) : super(key: key);

  final RegistrationType type;
  static const String routeName = 'RegistrationScreen';

  get title {
    String title = type == RegistrationType.signUp
        ? 'Sign Up'
        : type == RegistrationType.signIn
            ? 'Sign In'
            : 'Forget Password';
    return title;
  }

  get subTitle {
    String subTitle = type == RegistrationType.signUp
        ? 'Please enter your information below'
        : type == RegistrationType.signIn
            ? 'Sign in to continue'
            : 'Please type your email below and we can help you reset password.';
    return subTitle;
  }

  get image {
    Widget image = type == RegistrationType.signUp
        ? svgSignUp
        : type == RegistrationType.signIn
            ? svgSignIn
            : svgForgetPassword;
    return image;
  }

  get buttonText {
    String buttonText = type == RegistrationType.signUp
        ? 'Sign Up'
        : type == RegistrationType.signIn
            ? 'Sign In'
            : 'Send';
    return buttonText;
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String userName = '';
  String email = '';
  String password = '';
  save(context, AuthProvider authProvider, NoteProvider noteProvider,
      JournalProvider journalProvider) async {
    if (type == RegistrationType.signUp && userName.length < 3) {
      toastWidget(
          message: 'User Name should be more than 2 characters!',
          context: context);
    } else if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
            caseSensitive: false)
        .hasMatch(email)) {
      toastWidget(message: 'Please enter a valid email!', context: context);
    } else if (password.length < 7) {
      toastWidget(
          context: context,
          message: 'Password should be more than 6 characters');
    } else {
      if (type == RegistrationType.signUp) {
        authProvider.signUpWithEmailAndPassword(
            email: email,
            password: password,
            userName: userName,
            context: context);
      } else {
        bool isSigned = await authProvider.signInWithEmailAndPassword(
            email: email, password: password, context: context);
        if (isSigned) {
          await noteProvider.getAllNote();
          await journalProvider.getAllJournals();
          await Provider.of<TaskProvider>(context, listen: false).getAllTasks();
          await AppRouter.router
              .pushWithReplacementFunction(ChooseCardScreen());
        }
      }
    }
    // if (formKey.currentState!.validate()) {
    //   if (type == RegistrationType.signUp) {
    //     authProvider.signUpWithEmailAndPassword(
    //         email: email,
    //         password: password,
    //         userName: userName,
    //         context: context);
    //   } else {
    //     bool isSigned = await authProvider.signInWithEmailAndPassword(
    //         email: email, password: password, context: context);
    //     if (isSigned) {
    //       await noteProvider.getAllNote();
    //       AppRouter.router.pushWithReplacementFunction(ChooseCardScreen());
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Consumer3<AuthProvider, NoteProvider, JournalProvider>(
        builder: (context, authProvider, noteProvider, journalProvider, x) {
      return WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (ctx) {
                return DialogWidget(
                    dialogType: DialogType.quit,
                    entryType: 'entryType',
                    onOkPressed: (d) {
                      AppRouter.router.pop();
                      exit(0);
                    });
              });
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      myHeadtitle(),
                      SizedBox(height: 5.h),
                      mySubtitle(theme),
                      SizedBox(height: 30.h),
                      image,
                      SizedBox(height: 25.h),
                      myForm(context),
                      type == RegistrationType.forgetPassword
                          ? const SizedBox()
                          : myButtonTextUnderForm(theme),
                      SizedBox(height: 30.h),
                      myButton(
                          context, authProvider, noteProvider, journalProvider),
                      SizedBox(
                        height: 30.h,
                      ),
                      type == RegistrationType.forgetPassword
                          ? const SizedBox()
                          : Column(
                              children: [
                                myDevider(theme),
                                SizedBox(height: 17.h),
                                registerWithFaceOrGoogle(),
                                type == RegistrationType.signIn
                                    ? SizedBox(
                                        height: 20.h,
                                      )
                                    : const SizedBox(),
                                type == RegistrationType.signIn
                                    ? createAccount(theme)
                                    : const SizedBox()
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  GestureDetector createAccount(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        AppRouter.router.pushNamedWithReplacementFunction(
            RegistrationScreen.routeName, [RegistrationType.signUp]);
      },
      child: Text(
        'Create account',
        style: theme.textTheme.subtitle2!.copyWith(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Row registerWithFaceOrGoogle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Image.asset('assets/images/facebook_icon.png',
              width: 29.w, height: 29.h),
        ),
        SizedBox(
          width: 25.w,
        ),
        GestureDetector(
          child: Image.asset(
            'assets/images/google_icon.png',
            width: 29.w,
            height: 29.h,
          ),
        ),
      ],
    );
  }

  Stack myDevider(ThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Container(
            width: double.infinity,
            height: 1.h,
            color: Colors.grey[200], //
          ),
        ),
        Container(
          color: MyApp.scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            'or',
            style: theme.textTheme.headline4,
          ),
        ),
      ],
    );
  }

  myButton(BuildContext context, AuthProvider authProvider,
      NoteProvider noteProvider, JournalProvider journalProvider) {
    return ButtonWidget(
        text: buttonText,
        onPressed: () async {
          if (type == RegistrationType.forgetPassword) {
          } else {
            save(context, authProvider, noteProvider, journalProvider);
          }
        },
        height: 48.h,
        width: 269.w);
  }

  Align myButtonTextUnderForm(ThemeData theme) {
    return Align(
      alignment: Alignment(0.87.w, 0),
      child: GestureDetector(
        onTap: () {
          AppRouter.router
              .pushNamedWithReplacementFunction(RegistrationScreen.routeName, [
            type == RegistrationType.signUp
                ? RegistrationType.signIn
                : RegistrationType.forgetPassword
          ]);
        },
        child: Text(
          type == RegistrationType.signUp
              ? 'I have an account'
              : 'Forget Password?',
          style: theme.textTheme.subtitle2,
        ),
      ),
    );
  }

  toastWidget({required String message, required BuildContext context}) {
    return showToast(
      message,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: Colors.grey[300],
      textStyle: Theme.of(context).textTheme.subtitle2,
    );
  }

  Form myForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(children: [
        type == RegistrationType.signUp
            ? CustomTextFieldWidget(
                hint: 'Username',
                validator: (value) {
                  if (value == null || value.length < 3) {
                    toastWidget(
                        message: 'User Name should be more than 2 characters!',
                        context: context);
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  userName = value;
                },
              )
            : const SizedBox(),
        CustomTextFieldWidget(
          hint: 'Email',
          validator: (value) {
            if (!RegExp(
                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
                    caseSensitive: false)
                .hasMatch(value ?? '')) {
              toastWidget(
                  message: 'Please enter a valid email!', context: context);
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            email = value;
          },
        ),
        type == RegistrationType.forgetPassword
            ? const SizedBox()
            : CustomTextFieldWidget(
                validator: (value) {
                  if (value == null || value.length < 7) {
                    toastWidget(
                        context: context,
                        message: 'Password should be more than 6 characters');
                  }
                  return null;
                },
                hint: 'Password',
                isPassword: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  password = value;
                },
                textInputAction: TextInputAction.done,
              ),
      ]),
    );
  }

  Text mySubtitle(ThemeData theme) {
    return Text(
      subTitle,
      style: theme.textTheme.subtitle1,
      textAlign: TextAlign.center,
    );
  }

  Text myHeadtitle() {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black, //
        fontSize: 22.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
