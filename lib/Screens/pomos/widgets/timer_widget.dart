import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_timer/simple_timer.dart';
import '../../../provider/pomo_provider.dart';
import '../../../router/app_router.dart';
import '../../../utils/constants.dart';
import '../home/time_home_screen.dart';
import '../timer_fullscreen.dart';

class TimerWidget extends StatelessWidget {
  TimerWidget({Key? key, this.minutes = 25, required this.timerController})
      : super(key: key);
  int minutes;
  TimerController? timerController;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Consumer<PomoProvider>(
      builder: (context, provider, x) => Container(
        width: 256.w,
        height: 256.h,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x8CC192DA),
                spreadRadius: 3,
                blurRadius: 13,
                offset: Offset(0, 0),
                // changes position of shadow
              ),
            ]),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          alignment: Alignment(0, 0.4),
          children: [
            SimpleTimer(
              status: minutes == 1 || minutes == 15 ? TimerStatus.start : null,
              duration: Duration(minutes: minutes),
              controller:
                  minutes == 1 || minutes == 15 ? null : timerController,
              timerStyle: TimerStyle.ring,
              onStart: handleTimerOnStart,
              onEnd: () {
                handleTimerOnEnd(provider);
              },
              valueListener: (duration) {
                timerValueChangeListener(duration, provider);
              },
              backgroundColor: Colors.white,
              progressIndicatorColor: theme.colorScheme.secondary,
              progressIndicatorDirection:
                  TimerProgressIndicatorDirection.clockwise,
              progressTextCountDirection:
                  TimerProgressTextCountDirection.count_down,
              progressTextStyle: TextStyle(
                color: theme.primaryColor,
                fontSize: 41,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              strokeWidth: 5,
            ),
            if (provider.currentStatus == TimerStatuss.started)
              IconButton(
                icon: Icon(Icons.zoom_out_map_rounded, size: 20.r),
                onPressed: () {
                  AppRouter.router.pushFunction(TimerFullscreen(
                    duration: provider.duration,
                  ));
                },
              ),
            if (provider.currentStatus == TimerStatuss.paused)
              Positioned(
                top: 50.h,
                child: Text(
                  "Paused",
                  style: theme.textTheme.headline1!.copyWith(fontSize: 30),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void timerValueChangeListener(Duration timeElapsed, PomoProvider provider) {
    provider.setDuration(timeElapsed);
    print('Current Time ${minutes - timeElapsed.inMinutes}');
  }

  void handleTimerOnStart() {
    print("timer has just started");
  }

  void handleTimerOnEnd(PomoProvider provider) {
    if (minutes == 1) {
      Constants.playSound();
      AppRouter.router.pushNamedWithReplacementFunction(Constants.goOn);
    } else if (minutes == 15) {
      Constants.playSound();
      provider.setNumOfPomo();
      AppRouter.router.pushNamedWithReplacementFunction(Constants.homeScreen);
    } else {
      timerController!.reset();
      provider.setTimerStatus(TimerStatuss.stopped);
      provider.setTotalPomo();
      provider.setNumOfPomo();
      provider.setTotalMinutes();
      AppRouter.router
          .pushNamedWithReplacementFunction(Constants.gotPomoScreen);
    }

    print("timer has ended");
  }
}
