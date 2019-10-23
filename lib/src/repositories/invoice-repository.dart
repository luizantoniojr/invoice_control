import 'dart:async';
import 'package:inject/inject.dart';
import 'package:invoice_control/src/externalServices/firebase-service.dart';
import 'package:invoice_control/src/models/invoice.dart';

class InvoiceRepository {
  final FirebaseService firebaseService;

  @provide
  InvoiceRepository(this.firebaseService);

  Future<Invoice> fetchAllInvoices() {
    return firebaseService
        .fetchInvoices()
        .then((response) => Invoice.fromJson(response.data));
  }
}
