import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppbarTextFieldWidget extends StatelessWidget {
  const AppbarTextFieldWidget({
    Key? key,
    required this.onChanged,
    required this.hintText,
    required this.text,
    required this.autofocus,
  }) : super(key: key);

  final Function(String) onChanged;
  final String hintText;
  final String? text;
  final bool autofocus;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.w,
      child: TextField(
        cursorColor: Colors.grey,
        onChanged: onChanged,

        controller: TextEditingController(text: text),
        autofocus: autofocus,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          hintStyle: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: const Color(0x73C4C4C4)), //TODO: color
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: hintText,
        ),
        style: Theme.of(context)
            .textTheme
            .headline3!
            .copyWith(color: Colors.white), //TODO: color
      ),
    );
  }
}
