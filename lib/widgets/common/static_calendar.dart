import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'floating_calendar.dart';

class StaticCalendarWidget extends StatefulWidget {
  const StaticCalendarWidget({
    Key? key,
    required this.onDayPressed,
  }) : super(key: key);
  final Function(DateTime) onDayPressed;
  @override
  State<StaticCalendarWidget> createState() => _StaticCalendarWidgetState();
}

class _StaticCalendarWidgetState extends State<StaticCalendarWidget> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, // TODO;COLOR
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x26000000), //TODO: COLOR
                        offset: Offset(0, 1.h),
                        blurRadius: 3)
                  ]),
              child: SizedBox(
                width: double.infinity,
                height: 365.h,
              )),
          calendarCarouselWidget(theme),
        ],
      ),
    );
  }

  CalendarCarousel<Event> calendarCarouselWidget(ThemeData theme) {
    return CalendarCarousel(
      todayButtonColor: theme.colorScheme.secondary,
      showOnlyCurrentMonthDate: false,
      dayPadding: 5,
      showHeader: true,
      headerTitleTouchable: true,
      markedDatesMap: EventList<Event>(events: {
        DateTime(2022, 3, 28): [
          Event(
            date: DateTime(2022, 3, 28),
            title: 'Event 1',
          ),
        ]
      }),
      onHeaderTitlePressed: () async {
        var value = await floatingCalendarWidget(context);
        dateTime = value;
        widget.onDayPressed(value);
        setState(() {});
      },
      height: 365.h,
      width: 290.w,
      iconColor: theme.colorScheme.secondary,
      weekdayTextStyle: calendarTextStyle(
          color: theme.colorScheme.secondary, fontWeight: FontWeight.w600),
      selectedDateTime: dateTime,
      selectedDayButtonColor: theme.primaryColor,
      selectedDayTextStyle: calendarTextStyle(),
      daysTextStyle: calendarTextStyle(
        color: const Color(0xFFC192DA), //TODO: COLOR
      ),
      markedDateShowIcon: true,
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: theme.colorScheme.secondary)),
      todayTextStyle: calendarTextStyle(),
      headerTextStyle: calendarTextStyle(
          color: theme.colorScheme.secondary, fontWeight: FontWeight.w700),
      weekendTextStyle: calendarTextStyle(color: const Color(0xFFC192DA)),
      onDayPressed: (date, events) {
        dateTime = date;
        widget.onDayPressed(date);
        setState(() {});
        // Provider.of<NoteProvider>(context, listen: false)
        //     .setCurrentDayEvents(events);
      },
    );
  }
}

calendarTextStyle({color = Colors.white, fontWeight = FontWeight.w500}) {
  return TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: 15,
      fontFamily: 'Poppins');
}
