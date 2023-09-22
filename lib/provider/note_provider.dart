import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker_graduation/services/firestore_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import '../models/note_model.dart';

class NoteProvider extends ChangeNotifier {
  List<NoteModel> allNotes = [];
  List<NoteModel> selectedDayNotes = [];
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  EventList<Event> eventList = EventList<Event>(events: {});
  List<NoteModel> searchResult = [];

  NoteProvider() {
    getAllNote();
  }

  getAllNote() async {
    allNotes.clear();
    QuerySnapshot noteQuery =
        await FirestoreHelper.firestoreHelper.getAllNotes();
    allNotes = noteQuery.docs.map((note) => NoteModel.fromMap(note)).toList();
    setSelectedFlags();
    eventList.clear();
    addEvents();
    setSelectedDayNotes();
    notifyListeners();
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

  void updateNote(NoteModel note) async {
    await FirestoreHelper.firestoreHelper.updateNote(note);
    getAllNote();
  }

  NoteModel getNoteById(String? title) {
    return allNotes.where((element) => element.id == title).toList()[0];
  }

  void search(String value) {
    searchResult = allNotes.where((note) {
      String content = note.content.toLowerCase();
      String title = note.title.toLowerCase();
      String input = value.toLowerCase();

      if (input == '') {
        return false;
      }
      if (note.isLocked == true) {
        return title.contains(input);
      }
      return content.contains(input) || title.contains(input);
    }).toList();
    notifyListeners();
  }

//Calendar ////////////////////////////////////////////////////////////
  void setSelectedDay(DateTime date) {
    selectedDay = date;
    setSelectedDayNotes();
    notifyListeners();
  }

  void setSelectedDayNotes() {
    List<Event> events = eventList.getEvents(selectedDay);
    selectedDayNotes = events.map((e) {
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

//Selection Mode /////////////////////////////////////////////////
  void setSelectionMode() {
    isSelectionMode = selectedFlag.containsValue(true);
    notifyListeners();
  }

  void deleteSelectedNotes() {
    selectedFlag.forEach((key, value) async {
      if (value) {
        await FirestoreHelper.firestoreHelper
            .deleteNote(noteId: allNotes[key].id);
      }
    });

    isSelectionMode = false;
    getAllNote();
  }

  void setSelectedFlags() {
    selectedFlag = {};
    for (int i = 0; i < allNotes.length; i++) {
      selectedFlag[i] = false;
    }
  }
}
