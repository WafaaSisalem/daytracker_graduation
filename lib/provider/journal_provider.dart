import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker_graduation/services/auth_helper.dart';
import 'package:day_tracker_graduation/services/firestore_helper.dart';
import 'package:day_tracker_graduation/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import '../models/journal_model.dart';
import '../models/note_model.dart';
import '../models/user_model.dart';

class JournalProvider extends ChangeNotifier {
  List<JournalModel> allJournals = [];
  List<JournalModel> selectedDayJournals = []; //important
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  EventList<Event> eventList = EventList<Event>(events: {});
  UserModel? userModel;
  List<JournalModel> searchResult = [];

  JournalProvider() {
    if (AuthHelper.authHelper.getCurrentUser() != null) {
      getAllJournals();
      getUserModel();
    }
  }
  getUserModel() async {
    QuerySnapshot noteQuery =
        await FirestoreHelper.firestoreHelper.getUserModel();
    QueryDocumentSnapshot userMap = noteQuery.docs[0];
    userModel = UserModel(
        email: userMap[Constants.emailKey],
        userName: userMap[Constants.userNameKey],
        id: userMap[Constants.idKey],
        masterPassword: userMap[Constants.masterPassKey]);
    notifyListeners();
  }

  addJournal({
    required JournalModel journal,
  }) async {
    await FirestoreHelper.firestoreHelper.addJournal(
      journal: journal,
    );
    getAllJournals();
  }

  deleteJournal({required String journalId}) async {
    await FirestoreHelper.firestoreHelper.deleteJournal(journalId: journalId);
    getAllJournals();
  }

  getAllJournals() async {
    allJournals.clear();
    QuerySnapshot journalQuery =
        await FirestoreHelper.firestoreHelper.getAllJournals();
    allJournals = journalQuery.docs
        .map((journal) => JournalModel(
            location: journal[Constants.locationKey],
            id: journal[Constants.idKey],
            content: journal[Constants.contentKey],
            date: (journal[Constants.dateKey] as Timestamp).toDate(),
            isLocked: journal[Constants.isLockedKey] == 0 ? false : true))
        .toList();
    eventList.clear();
    addEvents();
    setSelectedDayJournals();

    notifyListeners();
  }

  void updateJournal(JournalModel journal) async {
    await FirestoreHelper.firestoreHelper.updateJournal(journal);
    getAllJournals();
  }

  void setSelectedDay(DateTime date) {
    //important
    selectedDay = date;
    setSelectedDayJournals();
    notifyListeners();
  }

  void setSelectedDayJournals() {
    List<Event> events = eventList.getEvents(selectedDay);
    selectedDayJournals = events.map((e) {
      return getJournalById(e.title);
    }).toList();
  }

  void addEvents() {
    for (int i = 0; i < allJournals.length; i++) {
      DateTime date = DateTime(allJournals[i].date.year,
          allJournals[i].date.month, allJournals[i].date.day);
      eventList.add(
        date,
        Event(date: date, title: allJournals[i].id),
      );
    }
  }

  JournalModel getJournalById(String? title) {
    return allJournals.where((element) => element.id == title).toList()[0];
  }

  void search(String value) {
    searchResult = allJournals.where((journal) {
      String content = journal.content.toLowerCase();
      String input = value.toLowerCase();
      if (input == '') {
        return false;
      }
      return content.contains(input);
    }).toList();
    notifyListeners();
  }

  void updateUser(UserModel user) async {
    await FirestoreHelper.firestoreHelper.updateUser(user);
    getUserModel();
  }

  void setSelectionMode() {
    isSelectionMode = selectedFlag.containsValue(true);
    notifyListeners();
  }

  void deleteSelectedJournals() {
    selectedFlag.forEach((key, value) {
      if (value) {
        deleteJournal(journalId: allJournals[key].id);
      }
    });
    selectedFlag = {};
    isSelectionMode = false;
  }
}
