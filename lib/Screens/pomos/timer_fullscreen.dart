import 'package:custom_timer/custom_timer.dart';
import 'package:day_tracker_graduation/provider/pomo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TimerFullscreen extends StatefulWidget {
  TimerFullscreen({Key? key, required this.duration}) : super(key: key);
  Duration? duration;

  @override
  State<TimerFullscreen> createState() => _TimerFullscreenState();
}

class _TimerFullscreenState extends State<TimerFullscreen>
    with SingleTickerProviderStateMixin {
  late final CustomTimerController _controller = CustomTimerController(
    vsync: this,
    initialState: CustomTimerState.counting,
    begin: Duration(
        minutes: 24 - (widget.duration!.inMinutes),
        seconds: 60 - widget.duration!.inSeconds),
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
                    //widget.timerController!.start();
                  },
                  child: Text(
                    Provider.of<PomoProvider>(context, listen: false)
                        .currentQuote
                        .toString(),
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
