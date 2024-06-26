import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:day_tracker_graduation/services/auth_helper.dart';
import 'package:day_tracker_graduation/services/firestorage_helper.dart';
import 'package:day_tracker_graduation/services/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/weather.dart';
import '../models/journal_model.dart';
import '../models/location_model.dart';
import '../utils/constants.dart';

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
  List<Map> allImagesUrls = []; // used in gallery tab to display all images
  List<Widget> urlsPicked = [];
  Set<Marker> markers = {};
  List<JournalModel> selectedLoc = [];
  List<Widget> pickedImages = <Widget>[];
  List<dynamic> urlImagesPicker = []; // the urls for an journal
  List<String> deletedUrl = [];
  bool urlIsSet = false;
//location part

  LocationModel? location;
  loc.LocationData? currentLocation;
  double? celsius;
  String formatedCelsius = '';

  bool isLocationServiceEnabled = false;
  JournalProvider() {
    if (AuthHelper.authHelper.getCurrentUser() != null) {
      getAllJournals();
    }
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
    await deleteImages(journalId);
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
            : 'https://firebasestorage.googleapis.com/v0/b/graduation-project-adedc.appspot.com/o/note.jpg?alt=media&token=66896385-8388-4ba0-aee6-00b29e328aef',
        size: 150,
        addBorder: true,
        borderColor: Colors.white,
        borderSize: 15,
      );
      selectedLoc.clear(); ///////////////
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
    selectedLoc = journalsHaveLoc.where((journal) {
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
        if (!journal.isLocked) {
          allImagesUrls.add({journal.id: url});
        }
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
      if (input == '' || journal.isLocked) {
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
    selectedFlag.forEach((key, value) async {
      if (value) {
        String id = allJournals[key].id;
        // deleteJournal(journalId: allJournals[key].id);
        deleteImages(id);
        await FirestoreHelper.firestoreHelper.deleteJournal(journalId: id);
      }
    });
    // selectedFlag = {};
    isSelectionMode = false;
    getAllJournals();
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
      notifyListeners();
    }
  }

  deleteImages(String journalId) async {
    JournalModel journal = getJournalById(journalId);
    await FirestorageHelper.firestorageHelper.deleteImages(journal.imagesUrls);
  }

  Future<List<File>> selectFiles() async {
    List<File> files = await FirestorageHelper.firestorageHelper.selectFile();
    pickedImages.addAll(
        files.map((file) => Image.file(file, fit: BoxFit.cover)).toList());

    notifyListeners();
    return files;
  }

  void removeImageAt(int index) {
    if (index < urlImagesPicker.length) {
      deletedUrl.add(urlImagesPicker[index]);
      urlImagesPicker.removeAt(index);
    }
    pickedImages.removeAt(index);
    notifyListeners();
  }

  void addImages(List<File> files) {
    pickedImages.addAll(
        files.map((file) => Image.file(file, fit: BoxFit.cover)).toList());
    notifyListeners();
  }

  void setUrlImages(List<dynamic> imagesUrls) {
    if (!urlIsSet) {
      if (imagesUrls.isNotEmpty) {
        urlImagesPicker = imagesUrls
            .map((url) => url)
            .toList(); //if i put urlimagesPIcker = imagesUrls; any change on picker will refelct on imagesurls
        List<Widget> images = imagesUrls
            .map((url) => CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: url,
                  placeholder: (context, url) => Container(
                    color: Colors.black12,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ))
            .toList();
        pickedImages.addAll(images);
        urlIsSet = true;
        notifyListeners();
      } //remove and see if changes
    }
  }

  void imagesClear() {
    pickedImages.clear();
    urlImagesPicker.clear();
    deletedUrl.clear();
    urlIsSet = false;
  }

  deleteImagesByUrls() async {
    if (deletedUrl.isNotEmpty) {
      await FirestorageHelper.firestorageHelper.deleteImages(deletedUrl);
    }
  }

//Location part
  getCurrentWeather() async {
    WeatherFactory wf = WeatherFactory("3117871fcf5c5c7027946e61b433701e");
    if (currentLocation != null ||
        (currentLocation?.latitude != 0.0 &&
            currentLocation?.longitude != 0.0)) {
      double lat = currentLocation!.latitude!;
      double lng = currentLocation!.longitude!;
      Weather w = await wf.currentWeatherByLocation(lat, lng);
      celsius = w.temperature?.celsius;
      formatedCelsius = '${w.temperature?.celsius?.round()}\u2103';
      notifyListeners();
      print(formatedCelsius);
    }
  }

  Future<void> checkLocationService() async {
    var location = loc.Location();
    isLocationServiceEnabled = await location.serviceEnabled();
    if (!isLocationServiceEnabled) {
      isLocationServiceEnabled = await location.requestService();
      if (!isLocationServiceEnabled) {
        // Location service is still not enabled, handle accordingly
        isGettingAddress = false;
        notifyListeners();
      }
    }
  }

  Future<String> getAddress(lat, lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        String? subLocality =
            placemark.subLocality == '' ? '' : "${placemark.subLocality},";
        String? thoroughfare =
            placemark.thoroughfare == '' ? '' : "${placemark.thoroughfare},";
        String? subThoroughfare = placemark.subThoroughfare == ''
            ? ''
            : "${placemark.subThoroughfare},";
        String? postalCode =
            placemark.postalCode == '' ? '' : "${placemark.postalCode},";
        String? subAdministrativeArea = placemark.subAdministrativeArea == ''
            ? ''
            : "${placemark.subAdministrativeArea},";
        String? administrativeArea = placemark.administrativeArea == ''
            ? ''
            : "${placemark.administrativeArea},";
        String? country = placemark.country == '' ? '' : "${placemark.country}";

        final address =
            '$subLocality $thoroughfare $subThoroughfare $postalCode $subAdministrativeArea $administrativeArea $country';

        return address;
      } else {
        return Constants.addressNotFound;
      }
    } catch (e) {
      print("Error: $e");
      return Constants.errorGettingAddress;
    }
  }

  bool isGettingAddress = false;
  Future<void> getLocation() async {
    var location1 = loc.Location();

    bool serviceEnabled = await location1.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location1.requestService();
      if (!serviceEnabled) {
        return;
      } else {
        await location1.serviceEnabled();
      }
    }

    var status = await Permission.location.status;
    if (status.isGranted) {
      try {
        isGettingAddress = true;
        notifyListeners();
        currentLocation = await location1.getLocation().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            isGettingAddress = false;

            notifyListeners();
            // showToast('Can\'t catch any location,try Again!',
            //     context: context, position: StyledToastPosition.top);
            return loc.LocationData.fromMap(
                {'longitude': 0.0, 'latitude': 0.0});
          },
        );

        double lat = currentLocation?.latitude ?? 0.0;
        double lng = currentLocation?.longitude ?? 0.0;
        String address = await getAddress(lat, lng);
        if (address == Constants.addressNotFound ||
            address == Constants.errorGettingAddress) {
        } else {
          location = LocationModel(lat, lng, await getAddress(lat, lng));
        }
        isGettingAddress = false;
        notifyListeners();
        if (currentLocation != null) {
          notifyListeners();
        }
      } catch (e) {
        print("Error: $e");
      }
    } else if (status.isDenied || status.isRestricted) {
      var result = await Permission.location.request();
      if (result.isGranted) {
        getLocation();
      }
    }
    // getCurrentWeather();
    getCurrentWeather();
  }

  void mapClear() {
    formatedCelsius = '';
    celsius = null;
    location = null;
    currentLocation = null;
  }
}
