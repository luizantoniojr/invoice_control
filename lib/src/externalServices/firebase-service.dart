import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inject/inject.dart';

class FirebaseService {
  @provide
  FirebaseService();

  Future<QuerySnapshot> fetch(String document, String ordedField) async {
    return Firestore.instance
        .collection(document)
        .orderBy(ordedField)
        .getDocuments();
  }

  void insert(String document, Map<String, dynamic> data) {
    Firestore.instance.collection(document).document().setData(data);
  }

  void update(String document, String documentId, Map<String, dynamic> data) {
    final DocumentReference reference =
        Firestore.instance.document('$document/$documentId');

    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      if (snapshot.exists) {
        data.forEach((key, value) =>
            transaction.update(reference, <String, dynamic>{key: value}));
      }
    });
  }
}
