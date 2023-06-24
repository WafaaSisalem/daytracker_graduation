import 'package:flutter/material.dart';

class DialogTextFieldWidget extends StatelessWidget {
  const DialogTextFieldWidget({
    Key? key,
    required this.onChanged,
    required this.hintText,
    required this.isObscured,
  }) : super(key: key);

  final Function(String) onChanged;
  final String hintText;
  final bool isObscured;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextField(
      style: theme.textTheme.subtitle2,
      cursorColor: Colors.grey, //  TODO: COLOR
      onChanged: onChanged,

      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.textTheme.headline4!
              .copyWith(color: Colors.grey), //TODO: COLOR
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: theme
                      .primaryColor))), // TODO CHANGE SELECT ICON COLOR  TO PRIMARY COLOR WHEN CLICT ON THE TEXT FIELD
      obscureText: isObscured ? true : false,
    );
  }
}
