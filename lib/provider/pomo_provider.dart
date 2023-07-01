import 'package:day_tracker_graduation/Screens/pomos/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../helpers/shared_preference_helper.dart';
import '../utils/constants.dart';

class PomoProvider extends ChangeNotifier {
  PomoProvider() {
    getAll();
  }
  int numOfPomo = 0;
  String? currentQuote = Constants.defQuot;
  int? totalPomo;
  int? totalMinutes;
  TimerStatuss currentStatus = TimerStatuss.stopped;
  // int timeValue = 0;
  Duration duration = const Duration();


  setNumOfPomo(){
    numOfPomo++ ;
    numOfPomo = numOfPomo>=4?0:numOfPomo;
    notifyListeners();
    saveNumOfPomoToSharedPref();
  }
  setTimerStatus(TimerStatuss currentStatus){
    this.currentStatus = currentStatus;
    notifyListeners();
  }
  setDuration(Duration duration){
    this.duration = duration;
    notifyListeners();
  }
  // setTimeValue(int timeValue){
  //   this.timeValue = timeValue;
  //   notifyListeners();
  // }
  setTotalPomo(){
    totalPomo = totalPomo!+1;
    notifyListeners();
    saveTotalPomoToSharedPref();
  }
  setTotalMinutes(){
    totalMinutes = totalMinutes! + duration.inMinutes;
    notifyListeners();
    saveTotalMinutesToSharedPref();
  }
  saveQuoteToSharedPref(String value) async {
    bool isSave = await SharedPreferenceHelper.sharedHelper
        .saveStringToSharedPreferences(Constants.quotKey, value);

    print(isSave ? "save string is ok " : "There is a wrong");
    getQuoteFromSharedPref();
  }
  saveTotalPomoToSharedPref() async {
    bool isSave = await SharedPreferenceHelper.sharedHelper
        .saveIntToSharedPreferences(Constants.totalPomoKey, totalPomo!);

    print(isSave ? "save int is ok " : "There is a wrong");
    getTotalPomoFromSharedPref();
  }
  saveNumOfPomoToSharedPref() async {
    bool isSave = await SharedPreferenceHelper.sharedHelper
        .saveIntToSharedPreferences(Constants.numPomoKey, numOfPomo);

    print(isSave ? "save int is ok " : "There is a wrong");
    getNumOfPomoFromSharedPref();
  }

  saveTotalMinutesToSharedPref() async {
    bool isSave = await SharedPreferenceHelper.sharedHelper
        .saveIntToSharedPreferences(Constants.minutesKey, totalMinutes!);

    print(isSave ? "save int is ok " : "There is a wrong");
    getTotalPomoFromSharedPref();
  }

  getQuoteFromSharedPref() async {
    currentQuote = await SharedPreferenceHelper.sharedHelper
        .getStringFromSharedPreferences(Constants.quotKey) ??
        Constants.defQuot;
    notifyListeners();
  }

  getTotalPomoFromSharedPref() async {
    totalPomo = await SharedPreferenceHelper.sharedHelper
        .getIntFromSharedPreferences(Constants.totalPomoKey) ??
        0;
    notifyListeners();
  }

  getNumOfPomoFromSharedPref() async {
    numOfPomo = await SharedPreferenceHelper.sharedHelper
        .getIntFromSharedPreferences(Constants.numPomoKey) ??
        0;
    notifyListeners();
  }

  getTotalMinutesFromSharedPref() async {
    totalMinutes = await SharedPreferenceHelper.sharedHelper
        .getIntFromSharedPreferences(Constants.minutesKey) ??
        0;
    notifyListeners();
  }

  getAll(){
    getQuoteFromSharedPref();
    getTotalPomoFromSharedPref();
    getTotalMinutesFromSharedPref();
    getNumOfPomoFromSharedPref();
  }
}