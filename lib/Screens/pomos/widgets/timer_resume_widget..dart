import 'package:day_tracker_graduation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_timer/simple_timer.dart' as timer;

import '../../../provider/pomo_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/dialog_widget.dart';
import '../home/time_home_screen.dart';
import 'motivation_text.dart';

class TimerResumeWidget extends StatelessWidget {
  TimerResumeWidget({Key? key, required this.timerController})
      : super(key: key);
  timer.TimerController? timerController;
  @override
  Widget build(BuildContext context) {
    final pomoProvider = Provider.of<PomoProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ButtonWidget(
            text: Constants.continued,
            onPressed: () {
              timerController!.start();
              pomoProvider.setTimerStatus(TimerStatuss.started);
            },
            width: 176.w,
            height: 40.h),
        SizedBox(
          height: 10.h,
        ),
        ButtonWidget(
          text: 'End',
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return DialogWidget(
                      dialogType: DialogType.end,
                      entryType: 'end',
                      onOkPressed: (value) {
                        if (pomoProvider.duration.inMinutes >= 1) {
                          pomoProvider.setTotalPomo();
                          pomoProvider.setNumOfPomo();
                          pomoProvider.setTotalMinutes();
                          timerController!.reset();
                          pomoProvider.setTimerStatus(TimerStatuss.stopped);
                          Navigator.pop(context);
                          AppRouter.router.pushNamedWithReplacementFunction(
                              Constants.gotPomoScreen);
                        } else {
                          timerController!.reset();
                          pomoProvider.setTimerStatus(TimerStatuss.stopped);
                          Navigator.pop(context);
                        }

                        print(value);
                      });
                });
          },
          width: 176.w,
          height: 40.h,
          bgColor: Colors.white,
        ),
        SizedBox(
          height: 40.h,
        ),
        MotivationText(text: 'KEEP GOING!!'),
        SizedBox(
          height: 15.h,
        ),
        Expanded(
          child: Image.asset('assets/images/continue.png'),
        ),
      ],
    );
  }
}
