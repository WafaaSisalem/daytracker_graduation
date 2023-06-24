import 'package:flutter/material.dart';

import '../../../widgets/common/no_entries_widget.dart';
import '../../../widgets/common/static_calendar.dart';
import '../../../widgets/svgs/svgs.dart';
import 'notes_tab.dart';

class CalendarTab extends StatelessWidget {
  const CalendarTab({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Column(
      children: [
        StaticCalendarWidget(
          onDayPressed: (date) {
            print(date);
          },
        ),
        Expanded(
            child: NotesTab(
          notes: [],
          noEntriesWidget: NoEntriesWidget(
            image: svgNoCalendarEntry,
            text: 'No notes entries on this day',
          ),
        ))
      ],
    );
  }
}
