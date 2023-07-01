import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/services/firestore_helper.dart';
import 'package:day_tracker_graduation/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart';

import '../models/note_model.dart';

class NoteProvider extends ChangeNotifier {
  List<NoteModel> allNotes = [];
  List<NoteModel> selectedDayNotes = []; //important
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  EventList<Event> eventList = EventList<Event>(events: {});

  NoteProvider() {
    getAllNote();
  }
  addNote({
    required NoteModel note,
  }) async {
    await FirestoreHelper.firestoreHelper.addNote(
      note: note,
    );
    getAllNote();
  }

  deleteNote({required String noteId}) async {
    await FirestoreHelper.firestoreHelper.deleteNote(noteId: noteId);
    getAllNote();
  }

  getAllNote() async {
    allNotes.clear();
    QuerySnapshot noteQuery =
        await FirestoreHelper.firestoreHelper.getAllNotes();
    allNotes = noteQuery.docs
        .map((note) => NoteModel(
            id: note[Constants.idKey],
            content: note[Constants.contentKey],
            date: (note[Constants.dateKey] as Timestamp).toDate(),
            title: note[Constants.titleKey],
            password: note[Constants.passwordKey]))
        .toList();
    eventList.clear();
    addEvents();
    setSelectedDayNotes();

    notifyListeners();
  }

  void updateNote(NoteModel? note) async {
    await FirestoreHelper.firestoreHelper.updateNote(note);
    getAllNote();
  }

  void setSelectedDay(DateTime date) {
    //important
    selectedDay = date;
    setSelectedDayNotes();
    notifyListeners();
  }

  void setSelectedDayNotes() {
    List<Event> events = eventList.getEvents(selectedDay);

    print(events.toString() + 'evetnttts');
    selectedDayNotes = events.map((e) {
      print(e.title.toString() + 'title');
      return getNoteById(e.title);
    }).toList();
  }

  void addEvents() {
    for (int i = 0; i < allNotes.length; i++) {
      DateTime date = DateTime(
          allNotes[i].date.year, allNotes[i].date.month, allNotes[i].date.day);
      eventList.add(
        date,
        Event(date: date, title: allNotes[i].id),
      );
    }
  }

  NoteModel getNoteById(String? title) {
    print(allNotes.where((element) => element.id == title).toList()[0]);
    return allNotes.where((element) => element.id == title).toList()[0];
  }
}
