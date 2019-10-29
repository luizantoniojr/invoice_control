import 'dart:async';
import 'package:inject/inject.dart';
import 'package:invoice_control/src/externalServices/firebase-service.dart';
import 'package:invoice_control/src/models/invoice-result.dart';
import 'package:invoice_control/src/models/invoice.dart';

class InvoiceRepository {
  final FirebaseService firebaseService;
  final String document = "invoices";

  @provide
  InvoiceRepository(this.firebaseService);

  Future<InvoiceResult> fetchAll() {
    var ordedField = "dueDay";

    return firebaseService
        .fetch(document, ordedField)
        .then((data) => InvoiceResult.fromJson(data.documents));
  }

  void update(Invoice invoice) {
    var map = invoice.toMap();
    return firebaseService.update(document, invoice.id, map);
  }

  void insert(Invoice invoice) {
    var map = invoice.toMap();
    return firebaseService.insert(document, map);
  }
}
