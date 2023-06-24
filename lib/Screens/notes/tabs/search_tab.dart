import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/note_model.dart';

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
  List<NoteModel> allNotes = [
    NoteModel(
        id: 1,
        content:
            'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece It is a long established fact that a readera piece It is...',
        date: DateFormat('MMMM d, y. EEE. hh:mm a').format(DateTime.now()),
        title: 'First note'),
    NoteModel(
        id: 2,
        content:
            'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece It is a long established fact that a readera piece It is...',
        date: DateFormat('MMMM d, y. EEE. hh:mm a').format(DateTime.now()),
        title: 'second note'),
    NoteModel(
        id: 3,
        content:
            'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece It is a long established fact that a readera piece It is...',
        date: DateFormat('MMMM d, y. EEE. hh:mm a').format(DateTime.now()),
        title: 'Third note'),
  ].reversed.toList();

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
