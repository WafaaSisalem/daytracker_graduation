import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FabWidget extends StatelessWidget {
  const FabWidget(
      {Key? key,
      required this.onPressed,
      required,
      this.icon = Icons.add_rounded})
      : super(key: key);

  final Function() onPressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: theme.primaryColor, offset: Offset(0, 0), blurRadius: 6.r),
        ],
      ),
      child: Container(
        width: 62.w,
        height: 62.h,
        child: FloatingActionButton(
          backgroundColor: theme.primaryColor,
          child: Icon(icon, size: 30.r, color: Colors.white), //TODO: COLOR
          onPressed: onPressed,
        ),
      ),
    );
  }
}
