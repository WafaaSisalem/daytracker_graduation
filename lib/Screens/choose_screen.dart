import 'dart:io';

import 'package:day_tracker_graduation/Screens/pomos/home/time_home_screen.dart';
import 'package:day_tracker_graduation/Screens/registration/registration_screen.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../router/app_router.dart';
import '../widgets/choose_card_widget.dart';
import 'journals/journal_home_screen.dart';
import 'notes/note_home_screen.dart';
import 'tasks/task_home_screen.dart';

class ChooseCardScreen extends StatelessWidget {
  const ChooseCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AuthProvider>(builder: (context, authProvider, x) {
        return WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return DialogWidget(
                      dialogType: DialogType.quit,
                      entryType: 'quit',
                      onOkPressed: (c) {
                        AppRouter.router.pop();
                        exit(0);
                      });
                });
            return false;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15.h),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CHOOSE',
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      fontSize: 20.sp,
                                    ),
                          ),
                          PopupMenuButton(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context) => [
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Text(
                                  "Setting",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Text(
                                  "Sign out",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                            onSelected: (item) {
                              if (item == 1) {
                                authProvider.signOut();
                                AppRouter.router.pushWithReplacementFunction(
                                    RegistrationScreen(
                                        type: RegistrationType.signIn));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ChooseCardWidget(
                        textDirection: MyDirection.left,
                        title: 'TASKS',
                        description:
                            'Write your tasks and what are you going to do, TRACK your tasks and progress',
                        imagePath: 'assets/images/tasks_card.png',
                        onPressed: () {
                          AppRouter.router.pushWithReplacementFunction(
                              const TaskHomeScreen());
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                    ChooseCardWidget(
                        title: 'Journal',
                        description:
                            'What are you thinking about? write your journal to TRACK your habits',
                        imagePath: 'assets/images/journal_card.png',
                        onPressed: () {
                          AppRouter.router.pushWithReplacementFunction(
                              const JournalHomeScreen());
                        },
                        textDirection: MyDirection.right),
                    SizedBox(
                      height: 20.h,
                    ),
                    ChooseCardWidget(
                        title: 'notes',
                        description:
                            'You do not have to remember everythings, just write notes',
                        imagePath: 'assets/images/note_card.png',
                        onPressed: () {
                          AppRouter.router.pushWithReplacementFunction(
                              const NoteHomeScreen());
                        },
                        textDirection: MyDirection.left),
                    SizedBox(
                      height: 20.h,
                    ),
                    ChooseCardWidget(
                        title: 'pomos',
                        description:
                            'devide your task and Manage your time by setting pomos',
                        imagePath: 'assets/images/pomo_card.png',
                        onPressed: () {
                          AppRouter.router.pushWithReplacementFunction(
                              const TimerHomeScreen());
                        },
                        textDirection: MyDirection.right),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
