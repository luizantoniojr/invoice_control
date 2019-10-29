import 'dart:async';
import 'package:inject/inject.dart';
import 'package:invoice_control/src/externalServices/firebase-service.dart';
import 'package:invoice_control/src/models/invoice.dart';

class InvoiceRepository {
  final FirebaseService firebaseService;
  final String document = "invoices";

  @provide
  InvoiceRepository(this.firebaseService);

  Future<List<Invoice>> fetchAll() {
    var ordedField = "dueDay";
    return firebaseService.fetch(document, ordedField).then((data) {
      List<Invoice> temp = [];
      for (int i = 0; i < data.documents.length; i++) {
        Invoice result = Invoice.fromJson(data.documents[i]);
        temp.add(result);
      }
      return temp;
    });
  }

  void insert(Invoice invoice) {
    var map = invoice.toMap();
    firebaseService.insert(document, map);
  }

  void update(Invoice invoice) {
    var map = invoice.toMap();
    firebaseService.update(document, invoice.id, map);
  }

  void delete(String id) {
    firebaseService.delete(document, id);
  }
}
