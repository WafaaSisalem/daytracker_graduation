import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker_graduation/models/note_model.dart';

import '../models/user_model.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static FirestoreHelper firestoreHelper = FirestoreHelper._();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static const String userCollectionName = 'users';
  static const String noteCollectionName = 'notes';
  addUser({required UserModel user}) async {
    try {
      await firebaseFirestore
          .collection(userCollectionName)
          .doc(user.id)
          .set(user.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  addNoteToUser(
      {required NoteModel note, required String userId}) async {
    try {
      await firebaseFirestore
          .collection(userCollectionName)
          .doc(userId)
          .collection(noteCollectionName)
          .add(note.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
