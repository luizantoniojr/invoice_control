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
    _value = data['value'];

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
}
