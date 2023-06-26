import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static FirestoreHelper firestoreHelper = FirestoreHelper._();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static const String userCollectionName = 'users';
  addUserToFirestore(Map<String, dynamic> userMap) async {
    try {
      await firebaseFirestore.collection(userCollectionName).add(userMap);
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
