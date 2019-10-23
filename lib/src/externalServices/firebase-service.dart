import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inject/inject.dart';

class FirebaseService {
  @provide
  FirebaseService();

  Future<DocumentSnapshot> fetchInvoices() async {
    return Firestore.instance.collection('invoices').document().get();
  }
}
