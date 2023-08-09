import 'package:day_tracker_graduation/Screens/journals/tabs/journal_tab.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/no_entries_widget.dart';
import '../../../utils/svgs/svgs.dart';

class JournalSearchScreen extends StatelessWidget {
  const JournalSearchScreen({
    Key? key,
  }) : super(
          key: key,
        );
  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(builder: (context, journalProvider, x) {
      return JournalTab(
        longPressActivated: false,
        journals: journalProvider.searchResult,
        noEntriesWidget: NoEntriesWidget(
          image: svgJournalSearchResult,
          text: 'No journals Entries Found',
        ),
      );
    });
  }
}
