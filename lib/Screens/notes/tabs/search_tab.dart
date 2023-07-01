import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/note_model.dart';

import '../../../utils/constants.dart';
import '../../../widgets/common/no_entries_widget.dart';
import '../../../widgets/svgs/svgs.dart';
import '../note_home_screen.dart';
import 'notes_tab.dart';

class SearchTab extends StatelessWidget {
  SearchTab({Key? key, required this.type})
      : super(
          key: key,
        );
  bool searchResult = true;
  final HomeScreenType type;
  // List<NoteModel> allNotes = [];

  @override
  Widget build(BuildContext context) {
    return NotesTab(
      notes: [],
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
  }
}
