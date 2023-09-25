import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget(
      {Key? key, required this.titlePlace, required this.actions})
      : super(key: key);

  final Widget titlePlace;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(58.h),
      child: AppBar(
        title: titlePlace,
        actions: actions,
        automaticallyImplyLeading: false,
        backgroundColor: theme.primaryColor, //
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(36.r))),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(58.h);
}
