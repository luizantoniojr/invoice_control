import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_control/src/formatters/currency-formatter.dart';

class Invoice {
  String _id;
  String _description;
  int _dueDay;
  double _value;
  List<DateTime> _paymentDates;

  Invoice(String description, double value, int dueDay) {
    this._description = description;
    this._value = value;
    this._dueDay = dueDay;
  }

  String get id => _id;
  String get description => _description;
  int get dueDay => _dueDay;
  double get value => _value;
  List<DateTime> get paymentDates => _paymentDates;

  set id(String id) {
    this._id = id;
  }

  set description(String description) {
    this._description = description;
  }

  set dueDay(int dueDay) {
    this._dueDay = dueDay;
  }

  set value(double value) {
    this._value = value;
  }

  Invoice.fromJson(DocumentSnapshot item) {
    _id = item.documentID;
    _description = item.data['description'];
    _dueDay = item.data['dueDay'];
    _value = item.data['value'].toDouble();
    _paymentDates = [];

    if (item.data['paymentDates'] != null) {
      List<DateTime> paymentDates = [];
      for (int i = 0; i < item.data['paymentDates'].length; i++) {
        paymentDates.add(item.data['paymentDates'][i].toDate());
      }
      _paymentDates = paymentDates;
    }
  }

  toMap() {
    var map = new Map<String, dynamic>();
    map['dueDay'] = this.dueDay;
    map['description'] = this.description;
    map['paymentDates'] = this.paymentDates;
    map['value'] = this.value;

    return map;
  }

  String get valueFormated {
    var valueFormated = "R\$ ${CurrencyFormatter().formatToCurrency(value)}";
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
