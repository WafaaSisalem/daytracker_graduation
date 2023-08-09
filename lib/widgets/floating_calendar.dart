import 'package:flutter/material.dart';

floatingCalendarWidget(BuildContext context) {
  ThemeData theme = Theme.of(context);
  var value = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
              colorScheme: ColorScheme.light(
            primary: theme.primaryColor,
          )),
          child: child!)).then((value) => value);
  return value;
}
