import 'package:day_tracker_graduation/provider/pomo_provider.dart';
import 'package:day_tracker_graduation/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_timer/simple_timer.dart' as timer;

import '../../../router/app_router.dart';
import '../../../widgets/common/button_widget.dart';
import '../../../widgets/common/dialog_widget.dart';
import '../home/home_screen.dart';

class TimerStopWidget extends StatelessWidget {
  TimerStopWidget(
      {Key? key, required this.timerController, this.isFromGoOn = false})
      : super(key: key);
  timer.TimerController? timerController;
  bool isFromGoOn;

  @override
  Widget build(BuildContext context) {
    final pomoProvider = Provider.of<PomoProvider>(context);
    return Column(
      children: [
        ButtonWidget(
            text: isFromGoOn ? Constants.goOn : Constants.start,
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
          text: isFromGoOn ? Constants.exit : 'Add Quote',
          onPressed: () {
            isFromGoOn
                ? AppRouter.router
                    .pushNamedWithReplacementFunction(Constants.homeScreen)
                : showDialog(
                    context: context,
                    builder: (context) {
                      return DialogWidget(
                          dialogType: DialogType.quote,
                          entryType: 'quote',
                          onOkPressed: (value) {
                            pomoProvider.saveQuoteToSharedPref(value);
                            Navigator.pop(context);
                            print(value);
                          });
                    });
          },
          width: 176.w,
          height: 40.h,
          bgColor: Colors.white,
        ),
        SizedBox(
          height: 20.h,
        ),
        Visibility(
          visible: !isFromGoOn,
          child: Text(
            "Today: ${pomoProvider.totalPomo} Pomos, ${pomoProvider.totalMinutes} Minutes",
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
