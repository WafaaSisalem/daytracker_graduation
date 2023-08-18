import 'package:day_tracker_graduation/Screens/pomos/home/break_screen.dart';
import 'package:day_tracker_graduation/Screens/pomos/widgets/pomo_app_bar.dart';
import 'package:day_tracker_graduation/router/app_router.dart';
import 'package:day_tracker_graduation/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../provider/pomo_provider.dart';
import '../../../widgets/button_widget.dart';

class GotPomoScreen extends StatelessWidget {
  const GotPomoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PomoAppBar(),
      body: Consumer<PomoProvider>(
        builder: (context, provider, x) => SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 60.h,
                  ),
                  Image.asset("assets/images/gift.png"),
                  SizedBox(
                    height: 30.h,
                  ),
                  _buildFirstText(
                      provider.numOfPomo < 4
                          ? Constants.getMess
                          : Constants.get4Mess,
                      context),
                  _buildSecText(
                      provider.numOfPomo < 4
                          ? Constants.relaxMess
                          : Constants.relaxLongMess,
                      context),
                  SizedBox(
                    height: 30.h,
                  ),
                  ButtonWidget(
                      text: Constants.relax,
                      onPressed: () {
                        AppRouter.router.pushWithReplacementFunction(
                            BreakScreen(
                                isLong: provider.numOfPomo < 4 ? false : true));
                      },
                      width: 176.w,
                      height: 40.h),
                  SizedBox(
                    height: 10.h,
                  ),
                  Visibility(
                    visible: provider.numOfPomo < 4,
                    child: ButtonWidget(
                      text: Constants.skip,
                      onPressed: () {
                        AppRouter.router
                            .pushNamedWithReplacementFunction(Constants.goOn);
                      },
                      width: 176.w,
                      height: 40.h,
                      bgColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ButtonWidget(
                    text: Constants.exit,
                    onPressed: () {
                      AppRouter.router.pushNamedWithReplacementFunction(
                          Constants.homeScreen);
                    },
                    width: 176.w,
                    height: 40.h,
                    bgColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstText(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .headline1!
          .copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSecText(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 15.sp),
    );
  }
}
