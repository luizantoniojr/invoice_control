class Invoice {
  String _id;
  String _description;
  int _dueDay;
  double _value;
  List<DateTime> _paymentDates;

  Invoice.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _description = parsedJson['description'];
    _dueDay = parsedJson['dueDay'];
    _value = parsedJson['value'];

    List<DateTime> paymentDates = [];
    for (int i = 0; i < parsedJson['paymentDates'].length; i++) {
      DateTime dateTime = DateTime(parsedJson['paymentDates'][i]);
      paymentDates.add(dateTime);
    }
    _paymentDates = paymentDates;
  }

  String get id => _id;
  String get description => _description;
  int get dueDay => _dueDay;
  double get value => _value;
  List<DateTime> get paymentDates => _paymentDates;
}
