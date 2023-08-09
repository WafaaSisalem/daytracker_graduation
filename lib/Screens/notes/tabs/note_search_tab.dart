import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/no_entries_widget.dart';
import '../../../utils/svgs/svgs.dart';
import 'notes_tab.dart';

class NoteSearchTab extends StatelessWidget {
  const NoteSearchTab({
    Key? key,
  }) : super(
          key: key,
        );
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(builder: (context, noteProvider, x) {
      return NotesTab(
          longPressActivated: false,
          notes: noteProvider.searchResult,
          noEntriesWidget: NoEntriesWidget(
            image: svgNoteSearchResult,
            text: 'No Notes Entries Found',
          ));
    });
  }
}
