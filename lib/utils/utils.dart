import 'package:intl/intl.dart';

String formatCurrency(int number) {
  final currency =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ');

  return currency.format(number);
}

String formatDate(String date) {
  final formatted =
      new DateFormat.yMMMMd('en_US').format(DateTime.parse(date)).toString();

  return formatted;
}

String formatTime(String time) {
  final formatted =
      new DateFormat.Hm().format(DateTime.parse("2020-07-27 $time")).toString();

  return formatted;
}

String formatAddTime(String time, int add) {
  final formatted = new DateFormat.Hm()
      .format(DateTime.parse("2020-07-27 $time").add(Duration(hours: add)))
      .toString();

  return formatted;
}
