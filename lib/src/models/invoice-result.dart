import 'package:invoice_control/src/models/invoice.dart';

class InvoiceResult {
  int _total;
  List<Invoice> _results = [];

  InvoiceResult.fromJson(List<Map<String, dynamic>> data) {
    _total = data.length;
    List<Invoice> temp = [];
    for (int i = 0; i < data.length; i++) {
      Invoice result = Invoice.fromJson(data[i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<Invoice> get results => _results;
  int get total => _total;
}
