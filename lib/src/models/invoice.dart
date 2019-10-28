import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Invoice {
  String _id;
  String _description;
  int _dayDue;
  double _value;
  List<DateTime> _paymentDates;

  String get id => _id;
  String get description => _description;
  int get dayDue => _dayDue;
  double get value => _value;
  List<DateTime> get paymentDates => _paymentDates;

  Invoice.fromJson(DocumentSnapshot item) {
    _id = item.documentID;
    _description = item.data['description'];
    _dayDue = item.data['dayDue'];
    _value = item.data['value'].toDouble();

    List<DateTime> paymentDates = [];
    for (int i = 0; i < item.data['paymentDates'].length; i++) {
      paymentDates.add(item.data['paymentDates'][i].toDate());
    }
    _paymentDates = paymentDates;
  }

  toMap() {
    var map = new Map<String, dynamic>();
    map['dayDue'] = this.dayDue;
    map['description'] = this.description;
    map['paymentDates'] = this.paymentDates;
    map['value'] = this.value;

    return map;
  }

  String get valueFormated {
    final currencyFormat = new NumberFormat("#,##0.00", "pt_BR");
    var valueFormated = "R\$ ${currencyFormat.format(value)}";
    return valueFormated;
  }

  bool get wasPayed {
    var dateNow = DateTime.now();
    return this.paymentDates.any(
        (item) => item.year == dateNow.year && item.month == dateNow.month);
  }

  bool checkIfWasPayed(DateTime paymentDate) {
    return this.paymentDates.any((item) =>
        item.year == paymentDate.year && item.month == paymentDate.month);
  }

  void removerPayment(DateTime paymentDate) {
    _paymentDates = _paymentDates
        .where((item) =>
            item.month != paymentDate.month && item.year == paymentDate.year)
        .toList();
  }
}
