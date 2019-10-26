import 'package:intl/intl.dart';

class Invoice {
  String _id;
  String _description;
  int _dayDue;
  double _value;
  List<DateTime> _paymentDates;

  Invoice.fromJson(Map<String, dynamic> data) {
    _id = data['id'];
    _description = data['description'];
    _dayDue = data['dayDue'];
    _value = data['value'].toDouble();

    List<DateTime> paymentDates = [];
    for (int i = 0; i < data['paymentDates'].length; i++) {
      paymentDates.add(data['paymentDates'][i].toDate());
    }
    _paymentDates = paymentDates;
  }

  String get id => _id;
  String get description => _description;
  int get dayDue => _dayDue;
  double get value => _value;
  List<DateTime> get paymentDates => _paymentDates;

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
