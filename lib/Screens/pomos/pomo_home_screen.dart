import 'package:day_tracker_graduation/Screens/pomos/timer_fullscreen.dart';
import 'package:day_tracker_graduation/provider/pomo_provider.dart';
import 'package:day_tracker_graduation/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_timer/simple_timer.dart';

import '../../helpers/shared_preference_helper.dart';
import '../../router/app_router.dart';
import '../../widgets/common/appbar_widget.dart';
import '../../widgets/common/button_widget.dart';
import '../../widgets/common/dialog_widget.dart';
import '../choose_screen.dart';
import 'package:provider/provider.dart';

enum TimerStatus { started, paused, continued, stoped }

class PomoHomeScreen extends StatefulWidget {
  const PomoHomeScreen({Key? key}) : super(key: key);
  static const String routeName = 'PomoHomeScreen';

  @override
  State<PomoHomeScreen> createState() => _PomoHomeScreenState();
}

class _PomoHomeScreenState extends State<PomoHomeScreen>
    with SingleTickerProviderStateMixin {
  TimerController? _timerController;

  // bool started = false;
  TimerStatus status = TimerStatus.stoped;

  @override
  void initState() {
    // initialize timercontroller
    _timerController = TimerController(this);
    super.initState();
  }

  @override
  void dispose() {
    if (status == TimerStatus.stoped) _timerController!.stop();
    _timerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(theme),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          _buildTitle(theme),
          SizedBox(
            height: 20.h,
          ),
          _buildQuoteContainer(theme),
          const SizedBox(
            height: 30,
          ),
          _buildTimer(theme),
          SizedBox(
            height: 30.h,
          ),
          _buildFirstButton(),
          SizedBox(
            height: 10.h,
          ),
          if (status == TimerStatus.stoped) ...[
            _buildSecondButton(context),
            SizedBox(
              height: 20.h,
            ),
            _buildRemainingPomoText(theme),
          ],
          if (status == TimerStatus.started) ...[
            Expanded(child: SizedBox()),
            _buildMotivationText(theme),
            Expanded(child: SizedBox()),
            Image.asset('assets/images/timer_isworking.png')
          ]
        ],
      )),
    );
  }

  Text _buildMotivationText(ThemeData theme) {
    return Text(
      'KEEP DOING HARD WORK',
      style: theme.textTheme.headline3,
    );
  }

  Text _buildRemainingPomoText(ThemeData theme) {
    return Text(
      'Today: 2 Pomos, 50 Minutes',
      style: theme.textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w600),
    );
  }

  ButtonWidget _buildSecondButton(BuildContext context) {
    return ButtonWidget(
      text: 'Add Quote',
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return DialogWidget(
                  dialogType: DialogType.quote,
                  entryType: 'quote',
                  onOkPressed: (value) {
                    Provider.of<PomoProvider>(context, listen: false)
                        .saveString(Constants.quotKey, value);
                    Navigator.pop(context);
                    print(value);
                  });
            });
      },
      width: 176.w,
      height: 40.h,
      bgColor: Colors.white,
    );
  }

  ButtonWidget _buildFirstButton() {
    return ButtonWidget(
        text: status == TimerStatus.started ? 'pause' : 'Start',
        onPressed: () {
          if (status == TimerStatus.started) {
            _timerController!.pause();
            status == TimerStatus.stoped;
            setState(() {});
          } else if (status == TimerStatus.stoped) {
            _timerController!.start();

            setState(() {
              status == TimerStatus.started;
            });
            print('hi');
          }
        },
        width: 176.w,
        height: 40.h);
  }

  Container _buildTimer(ThemeData theme) {
    return Container(
      width: 256,
      height: 256,
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
            duration: const Duration(minutes: 25),
            controller: _timerController,
            timerStyle: TimerStyle.ring,
            onStart: handleTimerOnStart,
            onEnd: handleTimerOnEnd,
            valueListener: timerValueChangeListener,
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
          if (status == TimerStatus.started)
            IconButton(
              icon: Icon(Icons.zoom_out_map_rounded, size: 20.r),
              onPressed: () {
                AppRouter.router.pushWithReplacementFunction(TimerFullscreen());
              },
            )
        ],
      ),
    );
  }

  Container _buildQuoteContainer(ThemeData theme) {
    return Container(
      width: 256.w,
      height: 80.h,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: const Color(0x28000000), //TODO: COLOR
              offset: Offset(0, 1.h),
              blurRadius: 3),
        ],
      ),
      child: Text(
        Provider.of<PomoProvider>(context, listen: true).currentQuote!,
        style: theme.textTheme.headline4,
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
      ),
    );
  }

  Text _buildTitle(ThemeData theme) {
    return Text(
      'FOCUS!!',
      style: theme.textTheme.headline1!.copyWith(letterSpacing: 5),
    );
  }

  AppbarWidget _buildAppbar(ThemeData theme) {
    return AppbarWidget(
        titlePlace: Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            Text(
              'Pomodoro',
              style: theme.textTheme.headline2,
            )
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              AppRouter.router.pushWithReplacementFunction(ChooseCardScreen());
            },
            itemBuilder: (BuildContext context) {
              return {
                'Back Home',
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ]);
  }

  void timerValueChangeListener(Duration timeElapsed) {}

  void handleTimerOnStart() {
    print("timer has just started");
  }

  void handleTimerOnEnd() {
    print("timer has ended");
  }
}
