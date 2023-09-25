import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteSettingsWidget extends StatelessWidget {
  NoteSettingsWidget({
    Key? key,
    required this.radioValue,
    required this.groupValue,
    required this.containerColor,
    required this.containerChild,
    required this.onTap,
  }) : super(key: key);
  final int radioValue;
  final Color containerColor;
  final Widget containerChild;
  final Function(int) onTap;
  final int groupValue;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap(radioValue),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: containerColor,
              boxShadow: const [
                BoxShadow(
                    color: Color(0x26000000), //
                    offset: Offset(0, 1),
                    blurRadius: 3)
              ],
            ),
            width: 117.w,
            height: 214.h,
            child: Center(
              child: containerChild,
            ),
          ),
        ),
        Radio(
          fillColor:
              MaterialStateColor.resolveWith((states) => theme.primaryColor),
          value: radioValue,
          groupValue: groupValue,
          onChanged: (value) {
            onTap(value as int);
          },
        ),
      ],
    );
  }
}
