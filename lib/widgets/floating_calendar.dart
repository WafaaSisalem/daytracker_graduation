import 'package:flutter/material.dart';

floatingCalendarWidget(BuildContext context, {required initialDate}) async {
  ThemeData theme = Theme.of(context);
  var value = await showDatePicker(
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
  TimeOfDay? time;
  if (value != null) {
    time = await timePickerWidget(context, initialTime: TimeOfDay.now());
  }
  time ??= TimeOfDay.now();
  DateTime dateTime = value != null
      ? DateTime(value.year, value.month, value.day, time.hour, time.minute)
      : DateTime.now();
  return dateTime;
}

timePickerWidget(BuildContext context, {required initialTime}) {
  var value = showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
              colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          )),
          child: child!)).then((value) => value);
  return value;
}
