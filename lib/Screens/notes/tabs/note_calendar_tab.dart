import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/no_entries_widget.dart';
import '../../../widgets/static_calendar.dart';
import '../../../utils/svgs/svgs.dart';
import 'notes_tab.dart';

class NoteCalendarTab extends StatelessWidget {
  const NoteCalendarTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(builder: (context, noteProvider, x) {
      return Column(
        children: [
          StaticCalendarWidget(
            eventList: noteProvider.eventList,
            onDayPressed: (date) {
              noteProvider
                  .setSelectedDay(DateTime(date.year, date.month, date.day));
              print(date);
            },
          ),
          Expanded(
              child: NotesTab(
            longPressActivated: false,
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
