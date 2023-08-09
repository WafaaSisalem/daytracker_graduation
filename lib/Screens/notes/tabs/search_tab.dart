import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/no_entries_widget.dart';
import '../../../utils/svgs/svgs.dart';
import '../note_home_screen.dart';
import 'notes_tab.dart';

class SearchTab extends StatelessWidget {
  SearchTab({Key? key, required this.type})
      : super(
          key: key,
        );
  final HomeScreenType type;
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(builder: (context, noteProvider, x) {
      return NotesTab(
        longPressActivated: false,
        notes: noteProvider.searchResult,
        noEntriesWidget: type == HomeScreenType.note
            ? NoEntriesWidget(
                image: svgNoteSearchResult,
                text: 'No Notes Entries Found',
              )
            : NoEntriesWidget(
                image: svgJournalSearchResult,
                text: 'No journals Entries Found',
              ),
      );
    });
  }
}
