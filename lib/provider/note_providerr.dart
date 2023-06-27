import 'package:flutter/material.dart';

import '../helpers/shared_preference_helper.dart';
import '../utils/constants.dart';

class NoteProvider extends ChangeNotifier {
  NoteProvider() {
    getString(Constants.quotKey);
  }

  String? currentQuote;

  saveString(String key, String value) async{
    bool isSave  = await SharedPreferenceHelper.sharedHelper
        .saveStringToSharedPreferences(key, value);

    print(isSave?"save string is ok ":"There is a wrong");
    getString(key);
  }

  getString(String key) async {
    currentQuote = await SharedPreferenceHelper.sharedHelper
            .getStringFromSharedPreferences(key) ??
        Constants.defQuot;
    notifyListeners();
  }
}
