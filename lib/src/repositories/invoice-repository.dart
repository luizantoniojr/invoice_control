import 'dart:async';
import 'package:inject/inject.dart';
import 'package:invoice_control/src/externalServices/firebase-service.dart';
import 'package:invoice_control/src/models/invoice-result.dart';

class InvoiceRepository {
  final FirebaseService firebaseService;

  @provide
  InvoiceRepository(this.firebaseService);

  Future<InvoiceResult> fetchAllInvoices() {
    return firebaseService.fetchInvoices().then((data) =>
        InvoiceResult.fromJson(
            data.documents.map((item) => item.data).toList()));
  }
}
