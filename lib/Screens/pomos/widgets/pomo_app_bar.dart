import 'package:day_tracker_graduation/widgets/back_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../router/app_router.dart';
import '../../../widgets/appbar_widget.dart';
import '../../choose_screen.dart';

class PomoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PomoAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppbarWidget(
        titlePlace: Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            Text(
              'Pomodoro',
              style: Theme.of(context).textTheme.headline2,
            )
          ],
        ),
        actions: const [
          BackHomeMenuWidget(),
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(58.h);
}
