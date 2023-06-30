import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_timer/simple_timer.dart' as timer;

import '../../../provider/pomo_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common/button_widget.dart';
import '../home/home_screen.dart';
import 'motivation_text.dart';

class TimerStartWidget extends StatelessWidget {
  TimerStartWidget({Key? key, required this.timerController}) : super(key: key);
  timer.TimerController? timerController;
  @override
  Widget build(BuildContext context) {
    final pomoProvider = Provider.of<PomoProvider>(context);
    return Column(
      //mainAxisSize: MainAxisSize.min,
      children: [
        ButtonWidget(
            text: Constants.pause,
            onPressed: () {
              timerController!.pause();
              pomoProvider.setTimerStatus(TimerStatuss.paused);
            },
            width: 176.w,
            height: 40.h),
        SizedBox(
          height: 50.h,
        ),
        MotivationText(text:'KEEP DOING HARD WORK'),
        SizedBox(
          height: 20.h,
        ),
        Expanded(child: Image.asset('assets/images/timer_isworking.png',))

      ],
    );
  }
}
