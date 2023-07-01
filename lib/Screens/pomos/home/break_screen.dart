import 'package:day_tracker_graduation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_timer/simple_timer.dart';

import '../../../provider/pomo_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common/button_widget.dart';
import '../widgets/pomo_app_bar.dart';
import '../widgets/timer_widget.dart';

class BreakScreen extends StatefulWidget {
  BreakScreen({Key? key, this.isLong = false}) : super(key: key);
  bool isLong;

  @override
  State<BreakScreen> createState() => _BreakScreenState();
}

class _BreakScreenState extends State<BreakScreen>
    with SingleTickerProviderStateMixin {
  TimerController? _timerController;

  @override
  void initState() {
    // initialize timercontroller
    _timerController = TimerController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final result =
        widget.isLong ? 'assets/images/long.png' : 'assets/images/short.png';

    return Scaffold(
      appBar: const PomoAppBar(),
      body: Consumer<PomoProvider>(
        builder: (context, provider, x) => SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                _buildTitle(context),
                SizedBox(
                  height: 20.h,
                ),
                TimerWidget(
                  timerController: _timerController,
                  minutes: widget.isLong ? 15 : 1,
                ),
                SizedBox(
                  height: 30.h,
                ),
                _buildFirstText(
                    widget.isLong ? Constants.longBreak : Constants.shortBreak,
                    context),
                SizedBox(
                  height: 30.h,
                ),
                ButtonWidget(
                    text: Constants.finish,
                    onPressed: () {
                      _timerController!.reset();
                      widget.isLong? provider.setNumOfPomo():null;
                      AppRouter.router.pushNamedWithReplacementFunction(
                          widget.isLong ? Constants.homeScreen : Constants.goOn);
                    },
                    width: 176.w,
                    height: 40.h),
                SizedBox(
                  height: 10.h,
                ),
                ButtonWidget(
                  text: Constants.exit,
                  onPressed: () {
                    AppRouter.router.pushNamedWithReplacementFunction(Constants.homeScreen);
                  },
                  width: 176.w,
                  height: 40.h,
                  bgColor: Colors.white,
                ),
                SizedBox(
                  height: 60.h,
                ),
                Expanded(
                  child: Image.asset(result),
                ),
                SizedBox(
                  height: 60.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _buildTitle(BuildContext context) {
    return Text(
      'Break',
      style: Theme.of(context).textTheme.headline1!.copyWith(letterSpacing: 5),
    );
  }

  Widget _buildFirstText(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4!,
    );
  }
}
