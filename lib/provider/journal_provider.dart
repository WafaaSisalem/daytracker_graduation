import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:day_tracker_graduation/services/auth_helper.dart';
import 'package:day_tracker_graduation/services/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/journal_model.dart';
import '../models/location_model.dart';

class JournalProvider extends ChangeNotifier {
  List<JournalModel> allJournals = [];
  List<JournalModel> selectedDayJournals = []; //important
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  EventList<Event> eventList = EventList<Event>(events: {});
  // UserModel? userModel;
  List<JournalModel> searchResult = [];
  List<Map> allImagesUrls = [];
  List<File> filesPicked = [];
  List<Widget> imagesPicked = <Widget>[];
  List<Widget> urlsPicked = [];
  Set<Marker> markers = {};
  List<JournalModel> seletctedLoc = [];
  JournalProvider() {
    if (AuthHelper.authHelper.getCurrentUser() != null) {
      getAllJournals();
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

  getAllMarkers() async {
    final markerList = await Future.wait(allJournals
        .where((journal) => journal.location!.address != '')
        .map((journal) async {
      final icon = await MarkerIcon.downloadResizePictureCircle(
        journal.imagesUrls.isNotEmpty
            ? journal.imagesUrls[0]
            : 'https://firebasestorage.googleapis.com/v0/b/graduation-project-adedc.appspot.com/o/note.jpg?alt=media&token=ce568055-7cea-4b08-a3ae-f0140fadee2d',
        size: 150,
        addBorder: true,
        borderColor: Colors.white,
        borderSize: 15,
      );
      seletctedLoc.clear(); ///////////////
      return Marker(
        onTap: () {
          getJournalsByLocation(journal.location);
        },
        icon: icon,
        markerId: MarkerId(journal.id),
        position: LatLng(journal.location!.lat, journal.location!.lng),
      );
    }).toSet());

    markers = Set<Marker>.from(markerList);
    notifyListeners();
  }

  getJournalsByLocation(LocationModel? loc) {
    List<JournalModel> journalsHaveLoc =
        allJournals.where((journal) => journal.location != null).toList();
    seletctedLoc = journalsHaveLoc.where((journal) {
      return journal.location!.address == loc!.address;
    }).toList();

    notifyListeners();
  }

  getAllJournals() async {
    allJournals.clear();
    QuerySnapshot journalQuery =
        await FirestoreHelper.firestoreHelper.getAllJournals();
    allJournals = journalQuery.docs
        .map((journal) => JournalModel.fromMap(journal))
        .toList();
    setSelectedFlags();
    eventList.clear();
    addEvents();
    setSelectedDayJournals();
    getAllImagesUrls();

    notifyListeners();
  }

  void setSelectedFlags() {
    selectedFlag = {};
    for (int i = 0; i < allJournals.length; i++) {
      selectedFlag[i] = false;
    }
  }

  getAllImagesUrls() {
    // imageUrls = allJournals.map((journal) {
    //   List<String> urls = journal.imagesUrls as List<String>;
    //   List<String> allUrls = [];

    //   allUrls.addAll(urls);

    //   return allUrls;
    // }).toList();
    allImagesUrls.clear();
    for (JournalModel journal in allJournals) {
      for (String url in journal.imagesUrls) {
        allImagesUrls.add({journal.id: url});
      }
      // allImagesUrls.addAll(journal.imagesUrls);
    }
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

  JournalModel getJournalById(String? id) {
    return allJournals.where((element) => element.id == id).toList()[0];
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

  // void updateUser(UserModel user) async {
  //   await FirestoreHelper.firestoreHelper.updateUser(user);
  //   getUserModel();
  // }

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
    // selectedFlag = {};
    isSelectionMode = false;
  }

  getImagesWidgets() {
    // if (images.isEmpty) {
    //   images =
    //       files.map((file) => Image.file(file, fit: BoxFit.cover)).toList();
    // } else {
    //   images.addAll(
    //       files.map((file) => Image.file(file, fit: BoxFit.cover)).toList());
    // }
  }

  void addFile(List<File> files) {
    filesPicked.addAll(files);
    imagesPicked.addAll(
        files.map((file) => Image.file(file, fit: BoxFit.cover)).toList());
    notifyListeners();
  }

  void addUrls(List imagesUrls) {
    if (urlsPicked.isEmpty) {
      urlsPicked = imagesUrls
          .map((url) => CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: url,
                placeholder: (context, url) => Container(
                  color: Colors.black12,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ))
          .toList();
      imagesPicked.addAll(urlsPicked);
      notifyListeners();
    }
  }
}
