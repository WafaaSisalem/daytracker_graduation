import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker_graduation/models/note_model.dart';
import 'package:day_tracker_graduation/models/task_model.dart';
import 'package:day_tracker_graduation/services/auth_helper.dart';

import '../models/journal_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static FirestoreHelper firestoreHelper = FirestoreHelper._();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//USERS DATABASE
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

  Future<QuerySnapshot<Map<String, dynamic>>> getUserModel() async {
    return await firebaseFirestore
        .collection(Constants.userCollectionName)
        .where(Constants.idKey,
            isEqualTo: AuthHelper.authHelper.getCurrentUser()!.uid)
        .get();
  }

  updateUser(UserModel user) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .update(user.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
//////////////////////////////////////////////////////////////

  //NOTES DATABASE
  Future<QuerySnapshot<Map<String, dynamic>>> getAllNotes() async {
    return await firebaseFirestore
        .collection(Constants.userCollectionName)
        .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
        .collection(Constants.noteCollectionName)
        .orderBy(Constants.dateKey, descending: true)
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

  updateNote(NoteModel note) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .collection(Constants.noteCollectionName)
          .doc(note.id)
          .update(note.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

////////////////////////////////////////////////////////
  ///Tasks Database
  Future<QuerySnapshot<Map<String, dynamic>>> getAllTasks() async {
    return await firebaseFirestore
        .collection(Constants.userCollectionName)
        .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
        .collection(Constants.taskCollectionName)
        .orderBy(Constants.dateKey, descending: true)
        .get();
  }

  addTask({required TaskModel task}) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .collection(Constants.taskCollectionName)
          .doc(task.id)
          .set(task.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  deleteTask({required String taskId}) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .collection(Constants.taskCollectionName)
          .doc(taskId)
          .delete();
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  updateTask(TaskModel task) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .collection(Constants.taskCollectionName)
          .doc(task.id)
          .update(task.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
////////////////////////////////////////////////////////

//JOURNAL DATABASE
  Future<QuerySnapshot<Map<String, dynamic>>> getAllJournals() async {
    return await firebaseFirestore
        .collection(Constants.userCollectionName)
        .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
        .collection(Constants.journalCollectionName)
        .orderBy(Constants.dateKey, descending: true)
        .get();
  }

  addJournal({required JournalModel journal}) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .collection(Constants.journalCollectionName)
          .doc(journal.id)
          .set(journal.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  deleteJournal({required String journalId}) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .collection(Constants.journalCollectionName)
          .doc(journalId)
          .delete();
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  updateJournal(JournalModel journal) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollectionName)
          .doc(AuthHelper.authHelper.getCurrentUser()!.uid)
          .collection(Constants.journalCollectionName)
          .doc(journal.id)
          .update(journal.toMap());
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
