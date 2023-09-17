import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker_graduation/services/auth_helper.dart';
import 'package:day_tracker_graduation/services/firestore_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import '../models/note_model.dart';

class NoteProvider extends ChangeNotifier {
  List<NoteModel> allNotes = [];
  List<NoteModel> selectedDayNotes = []; //important
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  EventList<Event> eventList = EventList<Event>(events: {});
  // UserModel? userModel;
  List<NoteModel> searchResult = [];

  NoteProvider() {
    if (AuthHelper.authHelper.getCurrentUser() != null) {
      getAllNote();

      // getUserModel();
    }
  }
  // getUserModel() async {
  //   QuerySnapshot noteQuery =
  //       await FirestoreHelper.firestoreHelper.getUserModel();
  //   QueryDocumentSnapshot userMap = noteQuery.docs[0];
  //   userModel = UserModel(
  //       email: userMap[Constants.emailKey],
  //       userName: userMap[Constants.userNameKey],
  //       id: userMap[Constants.idKey],
  //       masterPassword: userMap[Constants.masterPassKey]);
  //   notifyListeners();
  // }

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
    allNotes = noteQuery.docs.map((note) => NoteModel.fromMap(note)).toList();
    setSelectedFlags();
    // NoteModel(
    //     id: note[Constants.idKey],
    //     content: note[Constants.contentKey],
    //     date: (note[Constants.dateKey] as Timestamp).toDate(),
    //     title: note[Constants.titleKey],
    //     isLocked: note[Constants.isLockedKey] == 0 ? false : true)
    eventList.clear();
    addEvents();
    setSelectedDayNotes();

    notifyListeners();
  }

  void updateNote(NoteModel note) async {
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

  void search(String value) {
    searchResult = allNotes.where((note) {
      String content = note.content.toLowerCase();
      String title = note.title.toLowerCase();
      String input = value.toLowerCase();
      if (input == '') {
        return false;
      }
      return content.contains(input) || title.contains(input);
    }).toList();
    notifyListeners();
  }

  // void updateUser(UserModel user) async {
  //   await FirestoreHelper.firestoreHelper.updateUser(user);
  //   // getUserModel();
  // }

  void setSelectionMode() {
    isSelectionMode = selectedFlag.containsValue(true);
    notifyListeners();
  }

  void deleteSelectedNotes() {
    selectedFlag.forEach((key, value) async {
      if (value) {
        await FirestoreHelper.firestoreHelper
            .deleteNote(noteId: allNotes[key].id);

        // deleteNote(noteId: allNotes[key].id);
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
