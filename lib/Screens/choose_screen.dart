import 'package:day_tracker_graduation/Screens/pomos/pomo_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../router/app_router.dart';
import '../widgets/common/choose_card_widget.dart';
import 'journals/journal_home_screen.dart';
import 'notes/note_home_screen.dart';

class ChooseCardScreen extends StatelessWidget {
  const ChooseCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
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
                      style: TextStyle(
                          color: Colors.black, //TODO:COLOR
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    PopupMenuButton(
                      padding: EdgeInsets.zero,
                      //  TODO:SET THE COLOR
                      itemBuilder: (context) => [
                        //  const  PopupMenuItem<int>(
                        //     value: 0,
                        //     child: Text(
                        //       "Setting",
                        //       style: TextStyle(color: Colors.black),
                        //     ),
                        //   ),
                      ],
                      onSelected: (item) => {print(item)},
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
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry', //TODO: EDIT THE DESCRIPTION
                  imagePath: 'assets/images/tasks_card.png',
                  onPressed: () {}),
              SizedBox(
                height: 20.h,
              ),
              ChooseCardWidget(
                  title: 'Journal',
                  description:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                  imagePath: 'assets/images/journal_card.png',
                  onPressed: () {
                    AppRouter.router
                        .pushWithReplacementFunction(JournalHomeScreen());
                  },
                  textDirection: MyDirection.right),
              SizedBox(
                height: 20.h,
              ),
              ChooseCardWidget(
                  title: 'notes',
                  description:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                  imagePath: 'assets/images/note_card.png',
                  onPressed: () {
                    AppRouter.router
                        .pushWithReplacementFunction(NoteHomeScreen());
                  },
                  textDirection: MyDirection.left),
              SizedBox(
                height: 20.h,
              ),
              ChooseCardWidget(
                  title: 'pomos',
                  description:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                  imagePath: 'assets/images/pomo_card.png',
                  onPressed: () {
                    AppRouter.router
                        .pushWithReplacementFunction(PomoHomeScreen());
                  },
                  textDirection: MyDirection.right),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
