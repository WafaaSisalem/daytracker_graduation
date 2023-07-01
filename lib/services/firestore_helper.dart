import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker_graduation/models/note_model.dart';
import 'package:day_tracker_graduation/services/auth_helper.dart';

import '../models/user_model.dart';
import '../utils/constants.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static FirestoreHelper firestoreHelper = FirestoreHelper._();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  addUser({required UserModel user}) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(user.id)
          .set(user.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllNotes() async {
    return await firebaseFirestore
        .collection(Constants.userCollectionName)
        .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
        .collection(Constants.noteCollectionName)
        .orderBy(Constants.formatedDateKey, descending: true)
        .get();
  }

  addNote({required NoteModel note}) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .collection(Constants.noteCollectionName)
          .doc(note.id)
          .set(note.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  deleteNote({required String noteId}) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .collection(Constants.noteCollectionName)
          .doc(noteId)
          .delete();
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  updateNote(NoteModel? note) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .collection(Constants.noteCollectionName)
          .doc(note!.id)
          .update(note.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
