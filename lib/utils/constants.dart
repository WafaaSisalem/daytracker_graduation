import 'package:audioplayers/audioplayers.dart';

import '../main.dart';

class Constants {
  static const defQuot = "Small steps lead to big accomplishments!";
  static const quotKey = "Quot";
  static const String userCollectionName = 'users';
  static const String noteCollectionName = 'notes';
  static const String journalCollectionName = 'journals';

  static const String formatedDateKey = 'formatedDate';
  static const String emailKey = 'email';
  static const String masterPassKey = 'masterPassword';
  static const String userNameKey = 'userName';

  static const String dateKey = 'date';

  static const String contentKey = 'content';
  static const String locationKey = 'location';
  static const String titleKey = 'title';
  static const String idKey = 'id';
  static const String passwordKey = 'password';
  static const String isLockedKey = 'isLocked';
  static const String imageUrlKey = 'imageUrl';
  static const String dateFormat = 'MMMM d, y. EEE. hh:mm a';

  static const totalPomoKey = "totalPomo";
  static const statusKey = "status";
  static const happy = "happy";
  static const sad = "sad";
  static const normal = "normal";
  static const angry = "angry";
  static const numPomoKey = "numPomo";
  static const minutesKey = "Minutes";
  static const start = "Start";
  static const pause = "Pause";
  static const relax = "Relax";
  static const finish = "Finish";
  static const goOn = "Go On";
  static const skip = "Skip";
  static const exit = "Exit";
  static const breakScreen = 'BreakScreen';
  static const homeScreen = 'HomeScreen';
  static const continued = "Continue";
  static const doEnd = "Do you want to End the Pomo?";
  static const notSaved =
      "this record can't be saved because the focus duration is shorter than 20 mins.";
  static const gotPomoScreen = "GotPomoScreen";
  static const getMess = "You've got a pomo.";
  static const get4Mess = "You've got 4 pomos.";
  static const relaxMess = "Relax for 5 mins";
  static const shortBreak = "Take a short break,you worth it";
  static const longBreak = "Take a long break,you worth it";
  static const relaxLongMess = "Take along break,\n Relax for 15 mins";
  static const goOnMess = "Let's go on to the next pomo";

  static const mylocation = 'AlRemal st, Gaza, Palestine';
  static const addressNotFound = 'Address not found';
  static const errorGettingAddress = 'error getting address';

  // static Methods
  static void playSound() async {
    String audioPath = 'audios/break.wav';
    await audioPlayer.play(
      AssetSource(audioPath),
    );
  }
}
