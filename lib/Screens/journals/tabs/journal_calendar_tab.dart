import 'package:day_tracker_graduation/Screens/journals/tabs/journal_tab.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/no_entries_widget.dart';
import '../../../widgets/static_calendar.dart';
import '../../../utils/svgs/svgs.dart';

class JournalCalendarTab extends StatelessWidget {
  const JournalCalendarTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(builder: (context, journalProvider, x) {
      return Column(
        children: [
          StaticCalendarWidget(
            eventList: journalProvider.eventList,
            onDayPressed: (date) {
              journalProvider
                  .setSelectedDay(DateTime(date.year, date.month, date.day));
            },
          ),
          Expanded(
              child: JournalTab(
            longPressActivated: false,
            journals: journalProvider.selectedDayJournals,
            noEntriesWidget: NoEntriesWidget(
              image: svgNoCalendarEntry,
              text: 'No journals entries on this day',
            ),
          ))
        ],
      );
    });
  }
}
