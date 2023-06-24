import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_timer/simple_timer.dart';

class TimerFullscreen extends StatefulWidget {
  const TimerFullscreen({Key? key}) : super(key: key);

  @override
  State<TimerFullscreen> createState() => _TimerFullscreenState();
}

class _TimerFullscreenState extends State<TimerFullscreen>
    with SingleTickerProviderStateMixin {
  TimerController? _timerController;
  late CustomTimerController _controller = CustomTimerController(
    vsync: this,
    begin: const Duration(minutes: 25),
    end: const Duration(),
  );
  @override
  void initState() {
    _controller.start();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xff2D2D2D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTimer(
              controller: _controller,
              builder: (timerState, remainingTime) {
                return Text("${remainingTime.minutes}:${remainingTime.seconds}",
                    style: const TextStyle(
                        fontSize: 77.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'));
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              width: 250.w,
              child: TextButton(
                  onPressed: () {
                    _timerController!.start();
                  },
                  child: Text(
                    'Small steps lead to big accomplishments!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline4!
                        .copyWith(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
