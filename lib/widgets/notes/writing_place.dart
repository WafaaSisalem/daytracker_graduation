import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WritingPlaceWidget extends StatelessWidget {
  const WritingPlaceWidget({
    Key? key,
    required this.onChanged,
    required this.contentText,
    required this.hintText,
  }) : super(key: key);

  final Function(String) onChanged;
  final String? contentText;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextField(
      controller: TextEditingController(text: contentText),
      cursorColor: Colors.grey, //TODO: color
      onChanged: onChanged,
      style: theme.textTheme.headline4!.copyWith(height: 1.5.h),
      keyboardType: TextInputType.multiline,
      maxLines: 99999,
      decoration: InputDecoration(
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.all(0),
          hintText: hintText,
          hintStyle: theme.textTheme.headline4!
              .copyWith(color: const Color(0x80707070))), //TODO: color
    );
  }
}
