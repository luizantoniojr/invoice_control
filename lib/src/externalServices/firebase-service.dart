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
    Firestore.instance
        .collection(document)
        .document(documentId)
        .updateData(data);
  }

  void delete(String document, String documentId) {
    Firestore.instance.collection(document).document(documentId).delete();
  }
}
