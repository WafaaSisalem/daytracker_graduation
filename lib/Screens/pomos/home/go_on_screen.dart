import 'package:day_tracker_graduation/main.dart';
import 'package:day_tracker_graduation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_timer/simple_timer.dart';

import '../../../provider/pomo_provider.dart';
import '../../../utils/constants.dart';
import '../widgets/pomo_app_bar.dart';
import '../widgets/quote_container.dart';
import '../widgets/timer_resume_widget..dart';
import '../widgets/timer_start_widget.dart';
import '../widgets/timer_stop_widget..dart';
import '../widgets/timer_widget.dart';
import 'time_home_screen.dart';

class GoOnScreen extends StatefulWidget {
  const GoOnScreen({Key? key}) : super(key: key);

  @override
  State<GoOnScreen> createState() => _GoOnScreenState();
}

class _GoOnScreenState extends State<GoOnScreen>
    with SingleTickerProviderStateMixin {
  TimerController? _timerController;

  @override
  void initState() {
    // initialize timercontroller
    audioPlayer.stop();
    _timerController = TimerController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Consumer<PomoProvider>(
      builder: (context, provider, x) => WillPopScope(
        onWillPop: () => AppRouter.router
            .pushWithReplacementFunction(const TimerHomeScreen()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const PomoAppBar(),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                _buildTitle(theme),
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
                _buildFirstText(Constants.goOnMess, context),
                SizedBox(
                  height: 30.h,
                ),
                if (provider.currentStatus == TimerStatuss.stopped)
                  Expanded(
                    child: TimerStopWidget(
                      timerController: _timerController,
                      isFromGoOn: true,
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
      ),
    );
  }

  Text _buildTitle(ThemeData theme) {
    return Text(
      'FOCUS!!',
      style: theme.textTheme.headline1!.copyWith(letterSpacing: 5),
    );
  }

  Widget _buildFirstText(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4!,
    );
  }
}
