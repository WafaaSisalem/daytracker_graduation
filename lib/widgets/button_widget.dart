import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../main.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
    this.bgColor = color,
  }) : super(key: key);
  static const Color color = MyApp.primaryColor; //TODO: COLOR

  final String text;
  final Color bgColor;
  final Function onPressed;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                  color: MyApp.shadowColor, //TODO: COLOR
                  offset: Offset(0, 1.5.h),
                  blurRadius: 3)
            ],
            color: bgColor),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: theme.textTheme.headline3!.copyWith(
              color:
                  bgColor == color ? Colors.white : theme.colorScheme.secondary,
            ), //TODO:COLOR
          ),
        ),
      ),
    );
  }
}
