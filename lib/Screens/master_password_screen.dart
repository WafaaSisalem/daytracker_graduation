import 'package:day_tracker_graduation/models/journal_model.dart';
import 'package:day_tracker_graduation/models/note_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:day_tracker_graduation/router/app_router.dart';
import 'package:day_tracker_graduation/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../widgets/button_widget.dart';
import 'registration/widgets/textfield_widget.dart';
import '../utils/constants.dart';

class MasterPassScreen extends StatelessWidget {
  MasterPassScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  static const String routeName = 'MasterPassScreen';
  var item;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String masterPass = '';
  String reEnterPass = '';
  String currenPass = '';
  save(context, NoteProvider noteProvider, JournalProvider journalProvider,
      AuthProvider authProvider) async {
    if (masterPass.isEmpty) {
      toastWidget(message: 'Enter a master password!', context: context);
    } else if (reEnterPass.isEmpty) {
      toastWidget(
        message: 'You have to re-enter the password!',
        context: context,
      );
    } else if (reEnterPass != masterPass) {
      toastWidget(
        message: 'The new passwords do not match!',
        context: context,
      );
    } else {
      // UserModel user = UserModel(
      //     email: noteProvider.userModel!.email,
      //     userName: noteProvider.userModel!.userName,
      //     id: noteProvider.userModel!.id,
      //     masterPassword: masterPass);
      // noteProvider.updateUser(user);
      authProvider.updatePassword(masterPass);
      if (item is NoteModel) {
        noteProvider.updateNote(NoteModel.fromMap({
          ...item.toMap(),
          Constants.isLockedKey: 1,
        }));
      } else {
        journalProvider.updateJournal(JournalModel.fromMap({
          ...item.toMap(),
          Constants.isLockedKey: 1,
        }));
      }
      AppRouter.router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<NoteProvider, JournalProvider, AuthProvider>(
        builder: (context, noteProvider, journalProvider, authProvider, x) {
      return Scaffold(
        appBar: const AppbarWidget(
            titlePlace: Text('Master Password'), actions: []),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 48.w),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    myForm(context),
                    SizedBox(height: 30.h),
                    myButton(
                        context, noteProvider, journalProvider, authProvider),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  myButton(BuildContext context, noteProvider, journalProvider, authProvider) {
    return ButtonWidget(
        text: 'Change Password',
        onPressed: () async {
          // formKey.currentState!.validate();

          save(context, noteProvider, journalProvider, authProvider);
        },
        height: 48.h,
        width: 269.w);
  }

  toastWidget({required String message, required BuildContext context}) {
    return showToast(
      message,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
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
        CustomTextFieldWidget(
          hint: 'New Master Password',
          validator: (value) {
            if (value == null || value.isEmpty) {
              toastWidget(
                  message: 'Enter a master password!', context: context);
              return '';
            }
            return null;
          },
          keyboardType: TextInputType.visiblePassword,
          onChanged: (value) {
            masterPass = value;
          },
        ),
        CustomTextFieldWidget(
          hint: 'Re-enter Master Password',
          validator: (value) {
            if (value != masterPass) {
              toastWidget(
                message: 'The new passwords do not match!',
                context: context,
              );
              return '';
            }
            return null;
          },
          keyboardType: TextInputType.visiblePassword,
          onChanged: (value) {
            reEnterPass = value;
          },
        ),
        // type == RegistrationType.forgetPassword
        //     ? const SizedBox()
        //     : CustomTextFieldWidget(
        //         validator: (value) {
        //           if (value == null || value.length < 7) {
        //             toastWidget(
        //                 context: context,
        //                 message: 'Password should be more than 6 characters');
        //           }
        //           return null;
        //         },
        //         hint: 'Password',
        //         isPassword: true,
        //         keyboardType: TextInputType.visiblePassword,
        //         onChanged: (value) {
        //           password = value;
        //         },
        //         textInputAction: TextInputAction.done,
        //       ),
      ]),
    );
  }
}
