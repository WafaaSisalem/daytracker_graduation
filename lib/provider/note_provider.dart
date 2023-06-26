// import 'package:day_tracker_graduation/services/firestore_helper.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_calendar_carousel/classes/event.dart';
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

// import '../models/note_model.dart';

// class NoteProvider extends ChangeNotifier {
//   // String keyboard;
//   List<NoteModel> allNotes;
//   // List<NoteModel> searchResults;
//   // List<dynamic> currentEvents = [];
//   // EventList<Event> eventList = EventList<Event>(events: {});

//   NoteProvider() {
//     getAllNote();
//   }
//   insertNote(NoteModel note) async {
//     await FirestoreHelper.firestoreHelper.addNoteToUser(note: note, userId: userId)
//     // getAllNote();
//   }

//   getAllNote() async {
//     List notes = await DbHelper.dbHelper.getAllNotes();
//     allNotes = notes.reversed.toList();
//     eventList.clear();
//     allNotes.forEach((noteModel) {
//       List split = noteModel.date.split(' ');
//       String removeComma = split[1].replaceAll(new RegExp(r'[^\w\s]+'), '');
//       split[1] = removeComma;
//       eventList.add(
//           DateTime(
//               int.parse(split[2]), getMonthNum(split[0]), int.parse(split[1])),
//           Event(
//             date: DateTime(int.parse(split[2]), getMonthNum(split[0]),
//                 int.parse(split[1])),
//             title: noteModel.id.toString(),
//           ));
//     });
//     var date = new DateTime.now().toString();
//     var dateParse = DateTime.parse(date);
//     setCurrentDayEvents(eventList
//         .getEvents(DateTime(dateParse.year, dateParse.month, dateParse.day)));
//     notifyListeners();
//   }

//   getSpecificNote(id) async {
//     NoteModel specificNote =
//         await DbHelper.dbHelper.getSpecificNote(int.parse(id));
//     return specificNote;
//   }

//   setCurrentDayEvents(List events) {
//     List<String> idsFromAllNotes =
//         allNotes.map((e) => e.id.toString()).toList();
//     print(idsFromAllNotes);
//     List<String> idsFromEvents = [];
//     print(events.toString() + 'events');
//     events.forEach((e) {
//       idsFromEvents.add(e.title);
//     });
//     idsFromAllNotes.removeWhere((e) => !idsFromEvents.contains(e));
//     currentEvents = allNotes
//         .where((element) => idsFromAllNotes.contains(element.id.toString()))
//         .toList();
//     //  currentEvents = idsFromAllNotes.map((e) => getSpecificNote(e)).toList();
//     notifyListeners();
//   }

//   getSearchResults(String keyboard) async {
//     searchResults = await DbHelper.dbHelper.getSearchResults(keyboard);
//     notifyListeners();
//   }

//   deleteNote(NoteModel noteModel) async {
//     searchResults = null;
//     await DbHelper.dbHelper.deleteNote(noteModel.id);
//     getAllNote();
//   }

//   updateNote(NoteModel noteModel) async {
//     await DbHelper.dbHelper.updateNote(noteModel);
//     searchResults = null;
//     getAllNote();
//   }

//   setKeyboard(keyboard) {
//     this.keyboard = keyboard;
//     getSearchResults(keyboard);
//   }
// }
