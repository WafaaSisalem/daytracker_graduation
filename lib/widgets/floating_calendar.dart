import 'package:flutter/material.dart';

floatingCalendarWidget(BuildContext context, {required initialDate}) {
  ThemeData theme = Theme.of(context);
  var value = showDatePicker(
      context: context,
      initialDate: initialDate,
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
