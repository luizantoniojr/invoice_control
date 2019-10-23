class Invoice {
  String _id;
  String _description;
  int _dueDay;
  double _value;
  List<DateTime> _paymentDates;

  Invoice.fromJson(Map<String, dynamic> data) {
    _id = data['id'];
    _description = data['description'];
    _dueDay = data['dueDay'];
    _value = data['value'];

    //TODO: Corrigir erro ao criar DateTime.
    // List<DateTime> paymentDates = [];
    // for (int i = 0; i < data['paymentDates'].length; i++) {
    //   DateTime dateTime = DateTime(data['paymentDates'][i]);
    //   paymentDates.add(dateTime);
    // }
    // _paymentDates = paymentDates;
  }

  String get id => _id;
  String get description => _description;
  int get dueDay => _dueDay;
  double get value => _value;
  List<DateTime> get paymentDates => _paymentDates;
}
