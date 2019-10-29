import 'package:intl/intl.dart';

class CurrencyFormatter {
  final formatter = new NumberFormat("#,##0.00", "pt-br");

  double formatToNumber(String value) {
    return formatter.parse(value);
  }

  String formatToCurrency(double value) {
    return formatter.format(value);
  }
}
