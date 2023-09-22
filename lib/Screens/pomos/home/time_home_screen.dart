import 'package:day_tracker_graduation/Screens/pomos/widgets/pomo_app_bar.dart';
import 'package:day_tracker_graduation/Screens/pomos/widgets/timer_resume_widget..dart';
import 'package:day_tracker_graduation/main.dart';
import 'package:day_tracker_graduation/provider/pomo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_timer/simple_timer.dart';

import '../widgets/quote_container.dart';
import '../widgets/timer_start_widget.dart';
import '../widgets/timer_stop_widget..dart';
import '../widgets/timer_widget.dart';

enum TimerStatuss { started, paused, resume, stopped }

class TimerHomeScreen extends StatefulWidget {
  const TimerHomeScreen({Key? key}) : super(key: key);
  static const String routeName = 'PomoHomeScreen';

  @override
  State<TimerHomeScreen> createState() => _TimerHomeScreenState();
}

class _TimerHomeScreenState extends State<TimerHomeScreen>
    with SingleTickerProviderStateMixin {
  TimerController? _timerController;

  @override
  void initState() {
    // initialize timercontroller
    audioPlayer.stop();
    _timerController = TimerController(this);
    super.initState();
  }

  // @override
  // void dispose() {
  //   if (status == TimerStatus.stoped) _timerController!.stop();
  //   _timerController!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Consumer<PomoProvider>(
      builder: (context, provider, x) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const PomoAppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30.h,
              ),
              _buildTitle(
                  theme,
                  provider.currentStatus == TimerStatuss.paused
                      ? 'PAUSE'
                      : 'FOCUS!!'),
              SizedBox(
                height: 20.h,
              ),
              const QuoteContainer(),
              const SizedBox(
                height: 30,
              ),
              TimerWidget(
                timerController: _timerController,
              ),
              SizedBox(
                height: 30.h,
              ),
              if (provider.currentStatus == TimerStatuss.stopped)
                Expanded(
                  child: TimerStopWidget(
                    timerController: _timerController,
                  ),
                ),
              if (provider.currentStatus == TimerStatuss.started)
                Expanded(
                  child: TimerStartWidget(
                    timerController: _timerController,
                  ),
                ),
              if (provider.currentStatus == TimerStatuss.paused ||
                  provider.currentStatus == TimerStatuss.resume)
                Expanded(
                  child: TimerResumeWidget(
                    timerController: _timerController,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildTitle(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.headline1!.copyWith(letterSpacing: 5),
    );
  }
}
