import 'package:intl/intl.dart';

String formatCurrency(int number) {
  final currency =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ');

  return currency.format(number);
}