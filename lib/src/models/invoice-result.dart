import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_control/src/models/invoice.dart';

class InvoiceResult {
  int _total;
  List<Invoice> _results = [];

  InvoiceResult.fromJson(List<DocumentSnapshot> items) {
    _total = items.length;
    List<Invoice> temp = [];
    for (int i = 0; i < items.length; i++) {
      Invoice result = Invoice.fromJson(items[i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<Invoice> get results => _results;
  int get total => _total;
}
