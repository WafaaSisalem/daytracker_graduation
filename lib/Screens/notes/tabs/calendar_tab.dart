import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/common/no_entries_widget.dart';
import '../../../widgets/common/static_calendar.dart';
import '../../../widgets/svgs/svgs.dart';
import 'notes_tab.dart';

class CalendarTab extends StatelessWidget {
  const CalendarTab({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(builder: (context, noteProvider, x) {
      return Column(
        children: [
          StaticCalendarWidget(
            onDayPressed: (date) {
              noteProvider
                  .setSelectedDay(DateTime(date.year, date.month, date.day));
              print(date);
            },
          ),
          Expanded(
              child: NotesTab(
            notes: noteProvider.selectedDayNotes,
            noEntriesWidget: NoEntriesWidget(
              image: svgNoCalendarEntry,
              text: 'No notes entries on this day',
            ),
          ))
        ],
      );
    });
  }
}
